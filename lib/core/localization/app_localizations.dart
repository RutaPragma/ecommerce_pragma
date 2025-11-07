import 'dart:convert';
import 'package:ecommerce_pragma/core/localization/app_localizations_delegate.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  Future<bool> load() async {
    final jsonString = await rootBundle.loadString(
      'assets/lang/${locale.languageCode}.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap;

    return true;
  }

  Map<String, dynamic> get localizedStrings => _localizedStrings;

  String translate(String key) {
    final keys = key.split('.');
    dynamic value = _localizedStrings;

    for (final part in keys) {
      if (value is Map<String, dynamic> && value.containsKey(part)) {
        value = value[part];
      } else {
        return '** $part not found **';
      }
    }
    return value.toString();
  }
}
