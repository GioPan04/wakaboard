import 'package:flutter/material.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
