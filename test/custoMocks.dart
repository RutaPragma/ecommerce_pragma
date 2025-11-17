// ignore: file_names
import 'package:ecommerce_pragma/core/localization/app_localizations.dart';
import 'package:ecommerce_pragma/features/features.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart' show Mock;
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

class MockAuthPresenter extends Mock implements AuthPresenter {}

class FakeLocalizations extends AppLocalizations {
  FakeLocalizations() : super(const Locale('es'));
  @override
  Map<String, dynamic> get localizedStrings => {
    'auth_page': {
      'socialButtons': [
        {
          'label': 'Login with Google',
          'icon': 'google',
          'onPressed': 'googleLogin',
          'backgroundColor': Colors.white,
          'textColor': Colors.black,
        },
        {
          'label': 'Login with Apple',
          'icon': 'apple',
          'onPressed': 'AppleLogin',
          'backgroundColor': Colors.black,
          'textColor': Colors.white,
        },
      ],
    },
  };
}
