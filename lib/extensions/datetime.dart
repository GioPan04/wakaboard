extension DateTimeHelper on DateTime {
  bool isSameDay(DateTime other) {
    return difference(other).abs().inDays == 0;
  }
}
