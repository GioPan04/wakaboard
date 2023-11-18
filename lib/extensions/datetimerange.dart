import 'package:flutter/material.dart';

extension DateTimeRangeHelper on DateTimeRange {
  DateTimeRange get previusPeriod {
    final days = end.difference(start).inDays;
    final duration = Duration(days: days);

    return DateTimeRange(
      start: start.subtract(duration),
      end: end.subtract(duration),
    );
  }
}
