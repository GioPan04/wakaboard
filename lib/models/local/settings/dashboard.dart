import 'package:flutterwaka/models/local/dashboard_range.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard.freezed.dart';
part 'dashboard.g.dart';

@freezed
class DashboardSettings with _$DashboardSettings {
  const factory DashboardSettings({
    required DashboardRange range,
  }) = _DashboardSettings;

  factory DashboardSettings.fromJson(Map<String, Object?> json) =>
      _$DashboardSettingsFromJson(json);
}
