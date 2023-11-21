extension DurationHelper on Duration {
  String get format {
    if (inHours > 0) {
      return "$inHours hrs";
    } else {
      return "$inMinutes min";
    }
  }
}
