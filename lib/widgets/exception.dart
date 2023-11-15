import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExceptionButton extends StatelessWidget {
  final Object error;
  final StackTrace stacktrace;

  const ExceptionButton({
    required this.error,
    required this.stacktrace,
    super.key,
  });

  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(error.toString()),
        content: SingleChildScrollView(
          child: Text(
            stacktrace.toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontFamily: 'monospace'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: error.runtimeType == DioException &&
              (error as DioException).response?.statusCode == 402
          ? [
              const Icon(
                LucideIcons.euro,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                'Pro account required',
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                'This action requires a WakaTime pro account',
                style: theme.textTheme.bodySmall,
              ),
            ]
          : [
              const Text('An error occured'),
              const SizedBox(height: 5),
              OutlinedButton(
                onPressed: () => _openDialog(context),
                child: const Text('Details'),
              ),
            ],
    );
  }
}
