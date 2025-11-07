import 'package:flutter/material.dart';

import 'package:ecommerce_pragma/core/localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ecommerce_pragma/routes/app_router.dart';

import 'package:pragma_design_system/pragma_design_system.dart' as app_theme;

class MyApp extends StatelessWidget {
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
    );
  }
}
