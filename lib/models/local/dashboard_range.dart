typedef DateRangeBuilder = DateTime Function(DateTime);

enum DashboardRange {
  today('Today'),
  thisWeek('This week'),
  last7Days('Last 7 days'),
  last14Days('Last 14 days');

  const DashboardRange(this.label);

  final String label;

  DateTime buildRange(DateTime now, int weekday) {
    return switch (this) {
      DashboardRange.today => now,
      DashboardRange.last7Days => now.subtract(const Duration(days: 6)),
      DashboardRange.last14Days => now.subtract(const Duration(days: 13)),
      DashboardRange.thisWeek => DateTime(
          now.year,
          now.month,
          now.day - (now.weekday - weekday) % 7,
        ),
    };
  }
}
