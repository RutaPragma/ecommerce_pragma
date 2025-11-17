// test/commons/state/loading_provider_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_pragma/commons/state/loading_provider.dart';

void main() {
  group('LoadingNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('estado inicial debe ser false', () {
      // Arrange & Act
      final state = container.read(loadingNotifierProvider);

      // Assert
      expect(state, isFalse);
    });

    test('updateQuery cambia el estado de carga', () {
      // Arrange
      final notifier = container.read(loadingNotifierProvider.notifier);

      // Act
      notifier.updateQuery(true);
      final state = container.read(loadingNotifierProvider);

      // Assert
      expect(state, isTrue);
    });

    test('updateQuery puede cambiar de true a false', () {
      // Arrange
      final notifier = container.read(loadingNotifierProvider.notifier);
      notifier.updateQuery(true);

      // Act
      notifier.updateQuery(false);
      final state = container.read(loadingNotifierProvider);

      // Assert
      expect(state, isFalse);
    });

    test('clear establece el estado en false', () {
      // Arrange
      final notifier = container.read(loadingNotifierProvider.notifier);
      notifier.updateQuery(true);

      // Act
      notifier.clear();
      final state = container.read(loadingNotifierProvider);

      // Assert
      expect(state, isFalse);
    });
  });
}
