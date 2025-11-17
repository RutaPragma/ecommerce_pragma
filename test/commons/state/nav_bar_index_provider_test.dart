// test/commons/state/nav_bar_index_provider_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_pragma/commons/state/nav_bar_index_provider.dart';

void main() {
  group('NavBarIndexNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('estado inicial debe ser 0', () {
      // Arrange & Act
      final state = container.read(navBarIndexNotifierProvider);

      // Assert
      expect(state, 0);
    });

    test('setValue cambia el índice de navegación', () {
      // Arrange
      final notifier = container.read(navBarIndexNotifierProvider.notifier);

      // Act
      notifier.setValue(2);
      final state = container.read(navBarIndexNotifierProvider);

      // Assert
      expect(state, 2);
    });

    test('setValue puede establecer diferentes valores', () {
      // Arrange
      final notifier = container.read(navBarIndexNotifierProvider.notifier);

      // Act & Assert
      notifier.setValue(1);
      expect(container.read(navBarIndexNotifierProvider), 1);

      notifier.setValue(3);
      expect(container.read(navBarIndexNotifierProvider), 3);

      notifier.setValue(0);
      expect(container.read(navBarIndexNotifierProvider), 0);
    });

    test('reset establece el índice en 0', () {
      // Arrange
      final notifier = container.read(navBarIndexNotifierProvider.notifier);
      notifier.setValue(5);

      // Act
      notifier.reset();
      final state = container.read(navBarIndexNotifierProvider);

      // Assert
      expect(state, 0);
    });
  });
}
