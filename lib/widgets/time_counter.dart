import 'package:flutter/material.dart';

class TimeCounter extends StatelessWidget {
  final Duration duration;
  final TextStyle? timeStyle;
  final TextStyle? style;

  const TimeCounter({
    required this.duration,
    this.style,
    this.timeStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: duration.inHours.toString(),
            style: theme.textTheme.titleLarge?.merge(
              style?.merge(timeStyle) ?? timeStyle,
            ),
          ),
          TextSpan(
            text: ' hrs ',
            style: style,
          ),
          TextSpan(
            text: duration.inMinutes.remainder(60).toString(),
            style: theme.textTheme.titleLarge?.merge(
              style?.merge(timeStyle) ?? timeStyle,
            ),
          ),
          TextSpan(
            text: ' mins',
            style: style,
          ),
        ],
      ),
    );
  }
}
