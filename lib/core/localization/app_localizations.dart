import 'dart:convert';
import 'package:ecommerce_pragma/core/localization/app_localizations_delegate.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Clase que gestiona la localización y traducción de textos en la aplicación.
class AppLocalizations {
  /// Idioma actual de la aplicación.
  final Locale locale;

  late Map<String, dynamic> _localizedStrings;

  /// Crea una instancia de [AppLocalizations] para el [locale] dado.
  AppLocalizations(this.locale);

  /// Delegado de localización para Flutter.
  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  /// Obtiene la instancia de [AppLocalizations] desde el contexto.
  ///
  /// Retorna la instancia de [AppLocalizations] o lanza una excepción
  /// si no se encuentra en el árbol de widgets.
  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    if (instance == null) {
      throw Exception('AppLocalizations not found in widget tree');
    }
    return instance;
  }

  /// Carga el archivo de traducción correspondiente al idioma.
  Future<bool> load({String? jsonTest}) async {
    final jsonString =
        jsonTest ??
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap;

    return true;
  }

  /// Devuelve el mapa de traducciones cargado.
  Map<String, dynamic> get localizedStrings => _localizedStrings;

  /// Traduce una clave [key] usando el mapa de traducciones cargado.
  /// Si la clave no existe, retorna '** key not found **'.
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
