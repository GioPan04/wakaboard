import 'package:flutterwaka/models/category.dart';
import 'package:flutterwaka/models/editors.dart';
import 'package:flutterwaka/models/machine.dart';
import 'package:flutterwaka/models/operating_system.dart';
import 'package:flutterwaka/models/project.dart';

final class Summary {
  final List<SummaryDay> days;
  final DateTime start;
  final DateTime end;
  final Duration total;
  final Duration dailyAverage;

  const Summary({
    required this.days,
    required this.start,
    required this.end,
    required this.total,
    required this.dailyAverage,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      days:
          json['data'].map<SummaryDay>((d) => SummaryDay.fromJson(d)).toList(),
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      total: Duration(
        seconds: (json['cumulative_total']['seconds']),
      ),
      dailyAverage: Duration(
        seconds: (json['daily_average']['seconds'] as int).toInt(),
      ),
    );
  }
}

final class SummaryDay {
  final Duration total;
  final List<SummaryItem<Project>> projects;
  final List<SummaryItem<Editor>> editors;
  final List<SummaryItem<Machine>> machines;
  final List<SummaryItem<OperatingSystem>> operatingSystems;
  final List<SummaryItem<Category>> categories;
  final Range range;

  const SummaryDay({
    required this.total,
    required this.projects,
    required this.editors,
    required this.machines,
    required this.operatingSystems,
    required this.categories,
    required this.range,
  });

  factory SummaryDay.fromJson(Map<String, dynamic> json) {
    return SummaryDay(
      total: Duration(
        seconds: (json['grand_total']['total_seconds'] as int),
      ),
      range: Range.fromJson(json['range']),
      projects: json['projects']
          .map<SummaryItem<Project>>((p) => SummaryItem<Project>.fromJson(p))
          .toList(),
      editors: json['editors']
          .map<SummaryItem<Editor>>((p) => SummaryItem<Editor>.fromJson(p))
          .toList(),
      machines: json['machines']
          .map<SummaryItem<Machine>>((p) => SummaryItem<Machine>.fromJson(p))
          .toList(),
      operatingSystems: json['operating_systems']
          .map<SummaryItem<OperatingSystem>>(
              (p) => SummaryItem<OperatingSystem>.fromJson(p))
          .toList(),
      categories: json['categories']
          .map<SummaryItem<Category>>((p) => SummaryItem<Category>.fromJson(p))
          .toList(),
    );
  }
}

final class SummaryItem<T> {
  final String name;
  final double percent;
  final Duration duration;

  const SummaryItem({
    required this.name,
    required this.percent,
    required this.duration,
  });

  factory SummaryItem.fromJson(Map<String, dynamic> json) {
    return SummaryItem(
      name: json['name'],
      percent: json['percent'].toDouble(),
      duration: Duration(
        hours: json['hours'],
        minutes: json['minutes'],
        seconds: json['seconds'] ?? 0,
      ),
    );
  }
}

final class Range {
  final DateTime start;
  final DateTime end;
  final String date;
  final String timezone;

  const Range({
    required this.start,
    required this.end,
    required this.date,
    required this.timezone,
  });

  factory Range.fromJson(Map<String, dynamic> json) {
    return Range(
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      date: json['date'],
      timezone: json['timezone'],
    );
  }
}
