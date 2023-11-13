// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
      days: (json['data'] as List<dynamic>)
          .map((e) => SummaryDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      comulativeTotal: const SecondsDurationConverter()
          .fromJson(Summary._comTotValue(json, 'cumulative_total') as num),
      dailyAverage:
          DailyAverage.fromJson(json['daily_average'] as Map<String, dynamic>),
    );

SummaryDay _$SummaryDayFromJson(Map<String, dynamic> json) => SummaryDay(
      total: const SecondsDurationConverter()
          .fromJson(SummaryDay._totalValue(json, 'grand_total') as num),
      projects: (json['projects'] as List<dynamic>?)
          ?.map((e) => SummaryItem<Project>.fromJson(e as Map<String, dynamic>))
          .toList(),
      editors: (json['editors'] as List<dynamic>?)
          ?.map((e) => SummaryItem<Editor>.fromJson(e as Map<String, dynamic>))
          .toList(),
      machines: (json['machines'] as List<dynamic>?)
          ?.map((e) => SummaryItem<Machine>.fromJson(e as Map<String, dynamic>))
          .toList(),
      operatingSystems: (json['operatingSystems'] as List<dynamic>?)
          ?.map((e) =>
              SummaryItem<OperatingSystem>.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map(
              (e) => SummaryItem<Category>.fromJson(e as Map<String, dynamic>))
          .toList(),
      range: Range.fromJson(json['range'] as Map<String, dynamic>),
    );

SummaryItem<T> _$SummaryItemFromJson<T>(Map<String, dynamic> json) =>
    SummaryItem<T>(
      name: json['name'] as String,
      percent: (json['percent'] as num).toDouble(),
      duration: const SecondsDurationConverter()
          .fromJson(json['total_seconds'] as num),
    );

Range _$RangeFromJson(Map<String, dynamic> json) => Range(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      date: DateTime.parse(json['date'] as String),
      timezone: json['timezone'] as String,
    );

DailyAverage _$DailyAverageFromJson(Map<String, dynamic> json) => DailyAverage(
      daysIncludingHolidays: json['days_including_holidays'] as int,
      daysMinusHolidays: json['days_minus_holidays'] as int,
      holidays: json['holidays'] as int,
      duration:
          const SecondsDurationConverter().fromJson(json['seconds'] as num),
      durationIncludingOtherLanguage: const SecondsDurationConverter()
          .fromJson(json['seconds_including_other_language'] as num),
      text: json['text'] as String,
    );
