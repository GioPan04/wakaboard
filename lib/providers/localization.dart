import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = Provider<Locale>((ref) {
  final binding = WidgetsBinding.instance;
  final observer = _LocaleObserver((locales) {
    ref.state = locales!.first;
  });

  binding.addObserver(observer);

  ref.onDispose(() => binding.removeObserver(observer));

  return binding.platformDispatcher.locale;
});

class _LocaleObserver extends WidgetsBindingObserver {
  _LocaleObserver(this._didChangeLocales);

  final void Function(List<Locale>? locales) _didChangeLocales;

  @override
  void didChangeLocales(List<Locale>? locales) {
    _didChangeLocales(locales);
  }
}
