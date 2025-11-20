// test/commons/state/car_items_provider_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_pragma/commons/state/car_items_provider.dart';
import '../../base_widget.dart';

void main() {
  group('CarItemsNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('estado inicial debe ser un Set vacío', () {
      // Arrange & Act
      final state = container.read(carItemsNotifierProvider);

      // Assert
      expect(state, isEmpty);
    });

    test('addProduct agrega un producto al carrito', () {
      // Arrange
      final product = ProductItemMock.create(id: 1, title: 'Producto 1');

      // Act
      container.read(carItemsNotifierProvider.notifier).addProduct(product);
      final state = container.read(carItemsNotifierProvider);

      // Assert
      expect(state.length, 1);
      expect(state.first.id, 1);
    });

    test('removeProduct elimina un producto del carrito', () {
      // Arrange
      final product1 = ProductItemMock.create(id: 1, title: 'Producto 1');
      final product2 = ProductItemMock.create(id: 2, title: 'Producto 2');

      container.read(carItemsNotifierProvider.notifier).addProduct(product1);
      container.read(carItemsNotifierProvider.notifier).addProduct(product2);

      // Act
      container.read(carItemsNotifierProvider.notifier).removeProduct(1);
      final state = container.read(carItemsNotifierProvider);

      // Assert
      expect(state.length, 1);
      expect(state.first.id, 2);
    });

    test('addAmount incrementa la cantidad de un producto', () {
      // Arrange
      final product = ProductItemMock.create(id: 1, title: 'Producto 1');

      container.read(carItemsNotifierProvider.notifier).addProduct(product);

      // Act
      container.read(carItemsNotifierProvider.notifier).addAmount(1);
      final state = container.read(carItemsNotifierProvider);

      // Assert
      expect(state.first.amount, 2);
    });

    test('deleteAmount decrementa la cantidad de un producto', () {
      // Arrange
      final product = ProductItemMock.createWithAmount(id: 1, amount: 2);

      container.read(carItemsNotifierProvider.notifier).addProduct(product);

      // Act
      container.read(carItemsNotifierProvider.notifier).deleteAmount(1);
      final state = container.read(carItemsNotifierProvider);

      // Assert
      expect(state.first.amount, 1);
    });

    test('deleteAmount elimina el producto si amount es <= 0', () {
      // Arrange
      final product = ProductItemMock.createWithAmount(id: 1, amount: 1);

      container.read(carItemsNotifierProvider.notifier).addProduct(product);

      // Act
      container.read(carItemsNotifierProvider.notifier).deleteAmount(1);
      final state = container.read(carItemsNotifierProvider);

      // Assert
      expect(state, isEmpty);
    });

    test('reset limpia el carrito', () {
      // Arrange
      final product = ProductItemMock.create(id: 1);

      container.read(carItemsNotifierProvider.notifier).addProduct(product);

      // Act
      container.read(carItemsNotifierProvider.notifier).reset();
      final state = container.read(carItemsNotifierProvider);

      // Assert
      expect(state, isEmpty);
    });
  });
}
