import 'package:flutterwaka/models/category.dart';
import 'package:flutterwaka/models/converters/seconds_duration.dart';
import 'package:flutterwaka/models/editors.dart';
import 'package:flutterwaka/models/language.dart';
import 'package:flutterwaka/models/machine.dart';
import 'package:flutterwaka/models/operating_system.dart';
import 'package:flutterwaka/models/project.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stats.g.dart';

@JsonSerializable(createToJson: false)
@SecondsDurationConverter()
class Stats {
  @JsonKey(name: 'best_day')
  final DayStats? bestDay;
  final List<SummaryItem<Category>>? categories;
  final List<SummaryItem<Editor>>? editors;
  @JsonKey(name: 'operating_systems')
  final List<SummaryItem<OperatingSystem>>? operatingSystems;
  final List<SummaryItem<Project>>? projects;
  final List<SummaryItem<Machine>>? machines;
  final List<SummaryItem<Language>>? languages;
  @JsonKey(name: 'total_seconds')
  final Duration total;
  @JsonKey(name: 'daily_average')
  final Duration dailyAverage;

  const Stats({
    this.bestDay,
    this.categories,
    this.editors,
    this.operatingSystems,
    this.projects,
    this.machines,
    this.languages,
    required this.total,
    required this.dailyAverage,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);
}

@JsonSerializable(createToJson: false)
@SecondsDurationConverter()
class DayStats {
  final DateTime date;
  @JsonKey(name: 'total_seconds')
  final Duration total;

  const DayStats({
    required this.date,
    required this.total,
  });

  factory DayStats.fromJson(Map<String, dynamic> json) =>
      _$DayStatsFromJson(json);
}
