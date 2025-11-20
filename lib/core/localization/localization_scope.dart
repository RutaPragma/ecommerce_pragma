import 'package:ecommerce_pragma/commons/state/localization_provider.dart';
import 'package:ecommerce_pragma/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget que proporciona [AppLocalizations] inyectado como dependencia
/// en el árbol de widgets mediante [ProviderScope.overrides].
///
/// Este widget debe envolver la raíz de la aplicación (o la parte que use
/// la inyección de localizaciones) para que todos los widgets Consumer
/// puedan acceder a [localizationProvider].
///
/// **Ejemplo de uso:**
/// ```dart
/// LocalizationScope(
///   child: MyApp(),
/// )
/// ```
class LocalizationScope extends StatelessWidget {
  /// Widget hijo que tendrá acceso al provider inyectado.
  final Widget child;

  /// Crea una instancia de [LocalizationScope].
  const LocalizationScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );

    if (appLocalizations == null) {
      return child;
    }

    // Si hay una instancia válida, inyectamos el override para Riverpod.
    return ProviderScope(
      overrides: [localizationProvider.overrideWithValue(appLocalizations)],
      child: child,
    );
  }
}
