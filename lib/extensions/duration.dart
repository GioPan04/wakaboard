extension DurationHelper on Duration {
  String get shortFormat {
    if (inHours > 0) {
      return "$inHours hrs";
    } else {
      return "$inMinutes min";
    }
  }

  String get format {
    return "$inHours hrs ${inMinutes.remainder(60)} mins";
  }
}
