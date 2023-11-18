extension NumberHelper on num {
  String get asPercentage {
    return '${isNegative ? '-' : '+'}${(this * 100).abs().toStringAsFixed(2)}%';
  }
}
