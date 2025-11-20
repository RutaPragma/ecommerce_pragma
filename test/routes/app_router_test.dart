import 'dart:io';

import 'package:ecommerce_pragma/app.dart';
import 'package:ecommerce_pragma/commons/state/car_items_provider.dart';
import 'package:ecommerce_pragma/commons/state/nav_bar_index_provider.dart';
import 'package:ecommerce_pragma/commons/state/search_provider.dart';
import 'package:ecommerce_pragma/routes/app_router.dart';
import 'package:ecommerce_pragma/routes/path_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/product_state.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/products_notifier.dart';

import '../base_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppRouter integration', () {
    testWidgets('navega a detalle de producto y pagos', (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      HttpOverrides.global = TestHttpOverrides();

      final fakeProducts = FakeProductsNotifier();
      final fakeCarItems = FakeCarItemsNotifier(initialItems: {});
      final fakeNavBar = FakeNavBarIndexNotifier();

      fakeProducts.emitState(ProductDetailLoaded(createFakeProducts(count: 1).first));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productsNotifierProvider.overrideWith((ref) => fakeProducts),
            carItemsNotifierProvider.overrideWith((ref) => fakeCarItems),
            navBarIndexNotifierProvider.overrideWith((ref) => fakeNavBar),
            searchNotifierProvider.overrideWith((ref) => SearchNotifier()),
          ],
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Act: navegar a detalle de producto.
      appRouter.go(
        PathRoutes.productDetail,
        extra: {
          'productId': 1,
          'relatedProducts': const [],
          'productItem': ProductItemMock.create(),
        },
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(const Key('product_detail_page')), findsOneWidget);

      // Act: navegar a pagos.
      appRouter.go(
        PathRoutes.payments,
        extra: {'subtotal': '10', 'shipping': '3', 'total': '13'},
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(const Key('payments_checkout_template')), findsOneWidget);

      HttpOverrides.global = null;
    });
  });
}
