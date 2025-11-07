import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pragma_design_system/pragma_design_system.dart';
import 'package:reading_api_data_dart/domain/entities/entities.dart';

class ManagerProducts {
  ManagerProducts();

  Map<String, dynamic> getConfig({
    required Map<String, dynamic> config,
    required List<Map<String, dynamic>> productsProm,
    required List<Map<String, dynamic>> productsList,
  }) {
    config['sections'][0]['products'] = productsProm;
    config['sections'][1]['products'] = productsList;

    return config;
  }

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

  List<Map<String, dynamic>> getProducts(List<Product> data) {
    return data.map((e) => Product.toMap(e)).toList();
  }

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
