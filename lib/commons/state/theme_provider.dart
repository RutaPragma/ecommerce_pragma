import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notificador de estado para el modo de tema (claro/oscuro).
class ThemeNotifier extends StateNotifier<ThemeMode> {
  /// Crea un [ThemeNotifier] con tema claro por defecto.
  ThemeNotifier() : super(ThemeMode.light);

  /// Alterna entre tema claro y oscuro.
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

/// Provider global para el modo de tema de la aplicación.
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
