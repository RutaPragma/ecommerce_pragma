// test/commons/state/theme_provider_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_pragma/commons/state/theme_provider.dart';

void main() {
  group('ThemeNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('estado inicial debe ser ThemeMode.light', () {
      // Arrange & Act
      final state = container.read(themeNotifierProvider);

      // Assert
      expect(state, ThemeMode.light);
    });

    test('toggleTheme cambia de light a dark', () {
      // Arrange
      final notifier = container.read(themeNotifierProvider.notifier);

      // Act
      notifier.toggleTheme();
      final state = container.read(themeNotifierProvider);

      // Assert
      expect(state, ThemeMode.dark);
    });

    test('toggleTheme cambia de dark a light', () {
      // Arrange
      final notifier = container.read(themeNotifierProvider.notifier);
      notifier.toggleTheme(); // light -> dark

      // Act
      notifier.toggleTheme(); // dark -> light
      final state = container.read(themeNotifierProvider);

      // Assert
      expect(state, ThemeMode.light);
    });

    test('toggleTheme alterna correctamente múltiples veces', () {
      // Arrange
      final notifier = container.read(themeNotifierProvider.notifier);

      // Act & Assert
      expect(container.read(themeNotifierProvider), ThemeMode.light);

      notifier.toggleTheme();
      expect(container.read(themeNotifierProvider), ThemeMode.dark);

      notifier.toggleTheme();
      expect(container.read(themeNotifierProvider), ThemeMode.light);

      notifier.toggleTheme();
      expect(container.read(themeNotifierProvider), ThemeMode.dark);
    });
  });
}
