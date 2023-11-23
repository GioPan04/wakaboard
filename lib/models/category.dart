import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Category {
  coding,
  building,
  indexing,
  debugging,
  browsing,
  @JsonValue('running_tests')
  runningTests,
  @JsonValue('writing_tests')
  writingTests,
  @JsonValue('manual_testing')
  manualTesting,
  @JsonValue('writing_docs')
  writingDocs,
  @JsonValue('code_reviewing')
  codeReviewing,
  communicating,
  researching,
  learning,
  designing;
}
