import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Hatta Localization
/// Supports French, Arabic (RTL), and English
class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('fr'), // French (default)
    Locale('ar'), // Arabic (RTL)
    Locale('en'), // English
  ];

  /// Check if current locale is RTL
  bool get isRTL => locale.languageCode == 'ar';

  /// Load translations from JSON
  Future<bool> load() async {
    final jsonString = await rootBundle.loadString(
      'lib/core/l10n/translations/${locale.languageCode}.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  /// Translate a key
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  /// Shorthand for translate
  String t(String key) => translate(key);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fr', 'ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Extension for easy access to translations
extension LocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  String t(String key) => l10n.translate(key);
  bool get isRTL => l10n.isRTL;
}
