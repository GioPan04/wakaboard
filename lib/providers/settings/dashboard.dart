import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/local/dashboard_range.dart';
import 'package:flutterwaka/models/local/settings/dashboard.dart';
import 'package:flutterwaka/providers/shared_preferences.dart';

final dashboardSettingsProvider = StateProvider<DashboardSettings>(
  (ref) {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    final json = sharedPreferences.getString('settings.dashboard');
    late DashboardSettings settings;

    if (json == null) {
      settings = const DashboardSettings(
        range: DashboardRange.last14Days,
      );
    } else {
      settings = DashboardSettings.fromJson(jsonDecode(json));
    }

    ref.listenSelf((_, updated) {
      if (settings == updated) return;

      sharedPreferences.setString(
        'settings.dashboard',
        jsonEncode(updated.toJson()),
      );
    });

    return settings;
  },
);
