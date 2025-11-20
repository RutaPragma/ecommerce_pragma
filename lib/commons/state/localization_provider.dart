import 'package:ecommerce_pragma/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Proveedor que inyecta [AppLocalizations] como dependencia.
///
/// Este provider captura la instancia de [AppLocalizations] disponible
/// en el árbol de widgets y la proporciona como dependencia inyectable
/// para todas las páginas y widgets que necesiten acceso a traducciones.
///
/// **Nota**: Este provider debe ser overrideado en el contexto de la aplicación
/// (ej: MaterialApp o en la raíz del árbol) usando `ProviderScope.overrides`.
///
/// **Uso en widgets**:
/// ```dart
/// final language = ref.watch(localizationProvider);
/// final config = language.localizedStrings['section_key'];
/// ```
final localizationProvider = Provider<AppLocalizations>((ref) {
  throw UnimplementedError(
    'localizationProvider debe ser overrideado con AppLocalizations desde el contexto BuildContext',
  );
});

/// Utilidad para leer [AppLocalizations] desde [BuildContext].
///
/// Extrae la instancia de [AppLocalizations] del contexto usando [Localizations.of].
AppLocalizations _getLocalizationFromContext(BuildContext context) {
  return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
}

/// Familia de providers que permite inyectar localizaciones contextuales
/// de forma selectiva en widgets específicos.
///
/// Esta alternativa permite pasar el contexto explícitamente cuando es necesario.
final localizationFamilyProvider =
    Provider.family<AppLocalizations, BuildContext>((ref, context) {
      return _getLocalizationFromContext(context);
    });
