import 'package:flutterwaka/models/category.dart';
import 'package:flutterwaka/models/editors.dart';
import 'package:flutterwaka/models/language.dart';
import 'package:flutterwaka/models/machine.dart';
import 'package:flutterwaka/models/operating_system.dart';
import 'package:flutterwaka/models/project.dart';
import 'package:flutterwaka/models/summary.dart';

final class Stats {
  final DayStats bestDay;
  final List<SummaryItem<Category>> categories;
  final List<SummaryItem<Editor>> editors;
  final List<SummaryItem<OperatingSystem>> operatingSystems;
  final List<SummaryItem<Project>> projects;
  final List<SummaryItem<Machine>> machines;
  final List<SummaryItem<Language>> languages;

  const Stats({
    required this.bestDay,
    required this.categories,
    required this.editors,
    required this.operatingSystems,
    required this.projects,
    required this.machines,
    required this.languages,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      bestDay: DayStats.fromJson(json['best_day']),
      categories: json['categories']
          .map<SummaryItem<Category>>((p) => SummaryItem<Category>.fromJson(p))
          .toList(),
      editors: json['editors']
          .map<SummaryItem<Editor>>((p) => SummaryItem<Editor>.fromJson(p))
          .toList(),
      operatingSystems: json['operating_systems']
          .map<SummaryItem<OperatingSystem>>(
              (p) => SummaryItem<OperatingSystem>.fromJson(p))
          .toList(),
      projects: json['projects']
          .map<SummaryItem<Project>>((p) => SummaryItem<Project>.fromJson(p))
          .toList(),
      machines: json['machines']
          .map<SummaryItem<Machine>>((p) => SummaryItem<Machine>.fromJson(p))
          .toList(),
      languages: json['languages']
          .map<SummaryItem<Language>>((p) => SummaryItem<Language>.fromJson(p))
          .toList(),
    );
  }
}

final class DayStats {
  final DateTime day;
  final Duration total;

  const DayStats({
    required this.day,
    required this.total,
  });

  factory DayStats.fromJson(Map<String, dynamic> json) {
    return DayStats(
      day: DateTime.parse(json['date']),
      total: Duration(seconds: (json['total_seconds'] as double).toInt()),
    );
  }
}
