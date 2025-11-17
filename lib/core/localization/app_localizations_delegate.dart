import 'package:flutter/material.dart';
import 'package:ecommerce_pragma/core/localization/app_localizations.dart';

/// Delegado de localización para cargar los archivos de traducción.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  /// Crea un [AppLocalizationsDelegate].
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
