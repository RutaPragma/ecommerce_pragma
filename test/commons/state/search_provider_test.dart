// test/commons/state/search_provider_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_pragma/commons/state/search_provider.dart';

void main() {
  group('SearchNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('estado inicial debe ser una cadena vacía', () {
      // Arrange & Act
      final state = container.read(searchNotifierProvider);

      // Assert
      expect(state, '');
    });

    test('updateQuery actualiza el término de búsqueda', () {
      // Arrange
      final notifier = container.read(searchNotifierProvider.notifier);
      const query = 'producto';

      // Act
      notifier.updateQuery(query);
      final state = container.read(searchNotifierProvider);

      // Assert
      expect(state, query);
    });

    test('updateQuery puede cambiar múltiples veces', () {
      // Arrange
      final notifier = container.read(searchNotifierProvider.notifier);

      // Act & Assert
      notifier.updateQuery('búsqueda1');
      expect(container.read(searchNotifierProvider), 'búsqueda1');

      notifier.updateQuery('búsqueda2');
      expect(container.read(searchNotifierProvider), 'búsqueda2');

      notifier.updateQuery('otro término');
      expect(container.read(searchNotifierProvider), 'otro término');
    });

    test('clear limpia el término de búsqueda', () {
      // Arrange
      final notifier = container.read(searchNotifierProvider.notifier);
      notifier.updateQuery('búsqueda');

      // Act
      notifier.clear();
      final state = container.read(searchNotifierProvider);

      // Assert
      expect(state, '');
    });

    test('updateQuery con cadena vacía', () {
      // Arrange
      final notifier = container.read(searchNotifierProvider.notifier);
      notifier.updateQuery('búsqueda');

      // Act
      notifier.updateQuery('');
      final state = container.read(searchNotifierProvider);

      // Assert
      expect(state, '');
    });
  });
}
