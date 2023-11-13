import 'package:flutterwaka/models/category.dart';
import 'package:flutterwaka/models/converters/seconds_duration.dart';
import 'package:flutterwaka/models/editors.dart';
import 'package:flutterwaka/models/machine.dart';
import 'package:flutterwaka/models/operating_system.dart';
import 'package:flutterwaka/models/project.dart';
import 'package:json_annotation/json_annotation.dart';

part 'summary.g.dart';

@JsonSerializable(createToJson: false)
@SecondsDurationConverter()
class Summary {
  static Object? _comTotValue(Map j, String k) => j[k]['seconds'];

  @JsonKey(name: 'data')
  final List<SummaryDay> days;
  final DateTime start;
  final DateTime end;
  @JsonKey(name: 'cumulative_total', readValue: _comTotValue)
  final Duration comulativeTotal;
  @JsonKey(name: 'daily_average')
  final DailyAverage dailyAverage;

  const Summary({
    required this.days,
    required this.start,
    required this.end,
    required this.comulativeTotal,
    required this.dailyAverage,
  });

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);
}

@JsonSerializable(createToJson: false)
@SecondsDurationConverter()
class SummaryDay {
  static Object? _totalValue(Map j, String k) => j[k]['total_seconds'];

  @JsonKey(name: 'grand_total', readValue: _totalValue)
  final Duration total;
  final List<SummaryItem<Project>>? projects;
  final List<SummaryItem<Editor>>? editors;
  final List<SummaryItem<Machine>>? machines;
  final List<SummaryItem<OperatingSystem>>? operatingSystems;
  final List<SummaryItem<Category>>? categories;
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

  factory SummaryDay.fromJson(Map<String, dynamic> json) =>
      _$SummaryDayFromJson(json);
}

@JsonSerializable(createToJson: false)
@SecondsDurationConverter()
final class SummaryItem<T> {
  final String name;
  final double percent;
  @JsonKey(name: 'total_seconds')
  final Duration duration;

  const SummaryItem({
    required this.name,
    required this.percent,
    required this.duration,
  });

  factory SummaryItem.fromJson(Map<String, dynamic> json) =>
      _$SummaryItemFromJson(json);
}

@JsonSerializable(createToJson: false)
final class Range {
  final DateTime start;
  final DateTime end;
  final DateTime date;
  final String timezone;

  const Range({
    required this.start,
    required this.end,
    required this.date,
    required this.timezone,
  });

  factory Range.fromJson(Map<String, dynamic> json) => _$RangeFromJson(json);
}

@JsonSerializable(createToJson: false)
@SecondsDurationConverter()
class DailyAverage {
  @JsonKey(name: 'days_including_holidays')
  final int daysIncludingHolidays;
  @JsonKey(name: 'days_minus_holidays')
  final int daysMinusHolidays;
  final int holidays;
  @JsonKey(name: 'seconds')
  final Duration duration;
  @JsonKey(name: 'seconds_including_other_language')
  final Duration durationIncludingOtherLanguage;
  final String text;

  const DailyAverage({
    required this.daysIncludingHolidays,
    required this.daysMinusHolidays,
    required this.holidays,
    required this.duration,
    required this.durationIncludingOtherLanguage,
    required this.text,
  });

  factory DailyAverage.fromJson(Map<String, dynamic> json) =>
      _$DailyAverageFromJson(json);
}
