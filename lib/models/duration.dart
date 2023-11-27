import 'package:flutterwaka/models/converters/seconds_datetime.dart';
import 'package:flutterwaka/models/converters/seconds_duration.dart';
import 'package:json_annotation/json_annotation.dart';

part 'duration.g.dart';

@JsonSerializable(createToJson: false)
@SecondsDurationConverter()
@SecondsDateTimeConverter()
class WakaDuration {
  final String project;
  final Duration duration;
  final DateTime time;

  WakaDuration({
    required this.project,
    required this.duration,
    required this.time,
  });

  factory WakaDuration.fromJson(Map<String, dynamic> json) =>
      _$WakaDurationFromJson(json);
}
