// ignore: file_names
import 'package:pragma_design_system/pragma_design_system.dart';

class MockProductItem extends ProductItem {
  MockProductItem()
    : super(id: 1, title: 'Producto', price: '10.0', imageUrl: '', rating: 0.0);
}

/// Factory para crear instancias de [ProductItem] para tests.
class ProductItemMock {
  /// Crea un [ProductItem] con valores por defecto para tests.
  static ProductItem create({
    int id = 1,
    String title = 'Producto Test',
    String price = '10.0',
    String description = 'Descripción de prueba',
    String category = 'Categoría Test',
    String image = '',
    int amount = 1,
  }) {
    return ProductItem(
      id: id,
      title: title,
      price: price,
      imageUrl: image,
      rating: 100,
      amount: amount,
    );
  }

  /// Crea una lista de [ProductItem] para tests.
  static List<ProductItem> createList({int count = 3, int startId = 1}) {
    return List.generate(
      count,
      (index) => create(
        id: startId + index,
        title: 'Producto $index',
        price: ((index + 1) * 10.0).toString(),
      ),
    );
  }

  /// Crea un [ProductItem] con valores personalizados para tests específicos.
  static ProductItem createWithAmount({
    int id = 1,
    String title = 'Producto Test',
    String price = '10.0',
    int amount = 2,
  }) {
    return create(id: id, title: title, price: price, amount: amount);
  }
}
