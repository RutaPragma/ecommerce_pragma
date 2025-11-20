/// Biblioteca que contiene la configuración principal de la aplicación Flutter.
///
/// Este archivo define la estructura base de la aplicación, incluyendo:
/// - Configuración de temas
/// - Configuración de rutas
/// - Configuración de internacionalización
/// - Configuración del MaterialApp
import 'package:ecommerce_pragma/core/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ecommerce_pragma/routes/app_router.dart';
import 'package:pragma_design_system/pragma_design_system.dart' as app_theme;

/// Widget principal de la aplicación.
///
/// [MyApp] configura el MaterialApp.router con:
/// - Temas claro y oscuro
/// - Sistema de rutas
/// - Soporte para múltiples idiomas
/// - Delegados de localización
/// - [LocalizationScope] para inyectar [AppLocalizations] en toda la app
class MyApp extends StatelessWidget {
  /// Crea una instancia de [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: app_theme.lightTheme,
      darkTheme: app_theme.darkTheme,
      title: 'Ecommerce',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
      supportedLocales: const [Locale('en'), Locale('es')],
      builder: (context, child) {
        // `child` es el widget construido por MaterialApp (rutas, etc.).
        // Envolvemos con LocalizationScope ahora que las localizaciones
        // están disponibles en el contexto.
        return LocalizationScope(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
