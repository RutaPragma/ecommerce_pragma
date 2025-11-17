import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pragma_design_system/pragma_design_system.dart';
import 'package:reading_api_data_dart/domain/entities/entities.dart';

/// Clase utilitaria para la gestión y manipulación de productos en el dashboard.
class ManagerProducts {
  /// Crea una instancia de [ManagerProducts].
  ManagerProducts();

  /// Configura la estructura de productos promocionales y de lista en el mapa de configuración.
  ///
  /// [config]: Mapa de configuración base.
  /// [productsProm]: Lista de productos promocionales.
  /// [productsList]: Lista de productos generales.
  ///
  /// Retorna el mapa de configuración actualizado.
  Map<String, dynamic> getConfig({
    required Map<String, dynamic> config,
    required List<Map<String, dynamic>> productsProm,
    required List<Map<String, dynamic>> productsList,
  }) {
    config['sections'][0]['products'] = productsProm;
    config['sections'][1]['products'] = productsList;
    return config;
  }

  /// Filtra productos por categoría o título según el [query] de búsqueda.
  ///
  /// [products]: Lista de productos a filtrar.
  /// [query]: Texto de búsqueda.
  ///
  /// Retorna una lista de productos que coinciden con el query.
  List<Map<String, dynamic>> filterProducts({
    required List<Map<String, dynamic>> products,
    required String query,
  }) {
    final newList = products.where((product) {
      final category = product['category']?.toString().toLowerCase() ?? '';
      final title = product['title']?.toString().toLowerCase() ?? '';
      final search = query.toLowerCase();
      return category.contains(search) || title.contains(search);
    }).toList();
    return newList;
  }

  /// Convierte una lista de entidades [Product] a una lista de mapas.
  List<Map<String, dynamic>> getProducts(List<Product> data) {
    return data.map((e) => Product.toMap(e)).toList();
  }

  /// Obtiene una lista de productos promocionales aleatorios a partir de la lista de productos.
  ///
  /// Selecciona dos productos aleatoriamente y les agrega información de badge y rating.
  List<Map<String, dynamic>> getProductsPromotions(List<Product> data) {
    final random = Random();
    final selectedProm = [...data]..shuffle(random);
    final randomProducts = selectedProm.take(2).toList();
    return randomProducts.map((product) {
      final rating = Rating.toMap(product.rating);
      return {
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'category': product.category,
        'imageUrl': product.image,
        'badgeText': 'New',
        'badgeBackgroundColor': DSColorsFoundations.brandSecondaryDark,
        'badgeTextColor': Colors.black,
        'rating': rating['rate'],
      };
    }).toList();
  }

  /// Obtiene los productos del carrito y calcula el precio total.
  ///
  /// [itemsCar]: Conjunto de productos en el carrito.
  /// [price]: Precio inicial (usualmente 0).
  ///
  /// Retorna un mapa con la lista de productos y el precio total.
  Map<String, dynamic> getCartProducts(
    Set<ProductItem> itemsCar,
    double price,
  ) {
    final List<Map<String, dynamic>> productsCart = itemsCar.map((product) {
      price +=
          (double.parse(product.price) *
          double.parse(product.amount.toString()));
      return {
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'badgeText': 'New',
        'badgeBackgroundColor': DSColorsFoundations.brandSecondaryDark,
        'badgeTextColor': Colors.black,
        'amount': product.amount,
      };
    }).toList();
    return {'products': productsCart, 'price': price};
  }
}
