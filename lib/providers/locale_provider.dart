import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Manual app-language override. `null` = follow the device language.
class LocaleNotifier extends Notifier<Locale?> {
  static const _box = 'user';
  static const _key = 'locale';

  Box get _b => Hive.box(_box);

  @override
  Locale? build() {
    final code = _b.get(_key) as String?;
    return (code == null || code.isEmpty) ? null : Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    if (locale == null) {
      await _b.delete(_key);
    } else {
      await _b.put(_key, locale.languageCode);
    }
    state = locale;
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);

/// Supported languages with their native display names (not translated).
const supportedLanguages = <(String code, String name)>[
  ('en', 'English'),
  ('es', 'Español'),
  ('pt', 'Português'),
  ('fr', 'Français'),
  ('de', 'Deutsch'),
  ('ar', 'العربية'),
  ('hi', 'हिन्दी'),
  ('ja', '日本語'),
  ('zh', '中文'),
];

String languageNameFor(String code) =>
    supportedLanguages.firstWhere((l) => l.$1 == code, orElse: () => ('', '')).$2;
