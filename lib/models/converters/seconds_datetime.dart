import 'package:json_annotation/json_annotation.dart';

class SecondsDateTimeConverter implements JsonConverter<DateTime, num> {
  const SecondsDateTimeConverter();

  @override
  DateTime fromJson(num jsonValue) {
    if (jsonValue.runtimeType == int) {
      return DateTime.fromMillisecondsSinceEpoch(jsonValue.toInt() * 1000);
    } else if (jsonValue.runtimeType == double) {
      return DateTime.fromMillisecondsSinceEpoch((jsonValue * 1000).toInt());
    } else {
      throw UnimplementedError("${jsonValue.runtimeType} type not implemented");
    }
  }

  @override
  int toJson(DateTime object) {
    return object.millisecondsSinceEpoch;
  }
}
