import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_pragma/commons/state/car_items_provider.dart';
import 'package:ecommerce_pragma/commons/state/nav_bar_index_provider.dart';
import 'package:ecommerce_pragma/commons/state/search_provider.dart';
import 'package:ecommerce_pragma/features/dashboard/presentation/widgets/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';
import 'package:reading_api_data_dart/domain/entities/product_entities/product.dart';

import '../../../../base_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Map<String, dynamic> productsConfig;
  late FakeNavBarIndexNotifier navBarNotifier;
  late FakeCarItemsNotifier carItemsNotifier;

  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    final baseConfig = FakeAppLocalizations().localizedStrings['dashboard']
        ['productsWidget'] as Map<String, dynamic>;
    productsConfig =
        jsonDecode(jsonEncode(baseConfig)) as Map<String, dynamic>;

    navBarNotifier = FakeNavBarIndexNotifier();
    carItemsNotifier = FakeCarItemsNotifier(initialItems: {});
    addTearDown(() {
      HttpOverrides.global = null;
    });
  });

  Future<void> pumpProducts(
    WidgetTester tester, {
    required List<Product> products,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          navBarIndexNotifierProvider.overrideWith((ref) => navBarNotifier),
          carItemsNotifierProvider.overrideWith((ref) => carItemsNotifier),
          searchNotifierProvider.overrideWith((ref) => SearchNotifier()),
        ],
        child: MaterialApp(
          home: Products(config: productsConfig, listProducts: products),
        ),
      ),
    );
    await tester.pump();
  }

  group('Products Widget', () {
    testWidgets('muestra loader cuando no hay datos', (tester) async {
      // Arrange
      await pumpProducts(tester, products: const []);

      // Act & Assert
      expect(find.byType(DSLoader), findsOneWidget);
    });

    testWidgets('renderiza template cuando recibe productos', (
      tester,
    ) async {
      // Arrange
      final products = createFakeProducts(count: 2);
      await pumpProducts(tester, products: products);

      // Act & Assert
      expect(find.byKey(const Key('products_home_template')), findsOneWidget);
    });
  });
}
