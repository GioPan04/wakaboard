// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
      bestDay: json['best_day'] == null
          ? null
          : DayStats.fromJson(json['best_day'] as Map<String, dynamic>),
      categories: (json['categories'] as List<dynamic>?)
          ?.map(
              (e) => SummaryItem<Category>.fromJson(e as Map<String, dynamic>))
          .toList(),
      editors: (json['editors'] as List<dynamic>?)
          ?.map((e) => SummaryItem<Editor>.fromJson(e as Map<String, dynamic>))
          .toList(),
      operatingSystems: (json['operating_systems'] as List<dynamic>?)
          ?.map((e) =>
              SummaryItem<OperatingSystem>.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: (json['projects'] as List<dynamic>?)
          ?.map((e) => SummaryItem<Project>.fromJson(e as Map<String, dynamic>))
          .toList(),
      machines: (json['machines'] as List<dynamic>?)
          ?.map((e) => SummaryItem<Machine>.fromJson(e as Map<String, dynamic>))
          .toList(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map(
              (e) => SummaryItem<Language>.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: const SecondsDurationConverter()
          .fromJson(json['total_seconds'] as num),
      dailyAverage: const SecondsDurationConverter()
          .fromJson(json['daily_average'] as num),
    );

DayStats _$DayStatsFromJson(Map<String, dynamic> json) => DayStats(
      date: DateTime.parse(json['date'] as String),
      total: const SecondsDurationConverter()
          .fromJson(json['total_seconds'] as num),
    );
