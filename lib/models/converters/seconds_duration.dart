import 'package:json_annotation/json_annotation.dart';

class SecondsDurationConverter implements JsonConverter<Duration, num> {
  const SecondsDurationConverter();

  @override
  Duration fromJson(num jsonValue) {
    if (jsonValue.runtimeType == int) {
      return Duration(seconds: jsonValue.toInt());
    } else if (jsonValue.runtimeType == double) {
      return Duration(milliseconds: (jsonValue * 1000).toInt());
    } else {
      throw UnimplementedError("${jsonValue.runtimeType} type not implemented");
    }
  }

  @override
  int toJson(Duration object) {
    return object.inSeconds;
  }
}
