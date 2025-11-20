// test/features/product/presentation/pages/product_detail_test.dart

import 'dart:io';

import 'package:ecommerce_pragma/commons/state/car_items_provider.dart';
import 'package:ecommerce_pragma/commons/state/nav_bar_index_provider.dart';
import 'package:ecommerce_pragma/features/product/presentation/pages/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pragma_design_system/pragma_design_system.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/product_state.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/products_notifier.dart';

import '../../../../base_widget.dart';

/// Pruebas para la página de detalle de producto.
void main() {
  late Override overrideProductsNotifier;
  late Override overrideCarItemsNotifier;
  late Override overrideNavBarIndexNotifier;
  late FakeProductsNotifier fakeProductsNotifier;
  late FakeCarItemsNotifier fakeCarItemsNotifier;
  late FakeNavBarIndexNotifier fakeNavBarIndexNotifier;
  late ProductItem mockProductItem;

  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    fakeProductsNotifier = FakeProductsNotifier();
    fakeCarItemsNotifier = FakeCarItemsNotifier(initialItems: {});
    fakeNavBarIndexNotifier = FakeNavBarIndexNotifier();
    mockProductItem = ProductItemMock.create();

    overrideProductsNotifier =
        productsNotifierProvider.overrideWith((ref) => fakeProductsNotifier);
    overrideCarItemsNotifier =
        carItemsNotifierProvider.overrideWith((ref) => fakeCarItemsNotifier);
    overrideNavBarIndexNotifier = navBarIndexNotifierProvider.overrideWith(
      (ref) => fakeNavBarIndexNotifier,
    );

    addTearDown(() {
      HttpOverrides.global = null;
    });
  });

  Future<void> pumpProductDetail({
    required WidgetTester tester,
    ProductsState? state,
  }) async {
    if (state != null) {
      fakeProductsNotifier.emitState(state);
    }

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => const SizedBox.shrink(),
          routes: [
            GoRoute(
              path: 'product',
              builder: (context, _) => ProductDetail(
                productCode: 1,
                relateProducts: const [],
                productItem: mockProductItem,
              ),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          overrideProductsNotifier,
          overrideCarItemsNotifier,
          overrideNavBarIndexNotifier,
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
    router.push('/product');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('ProductDetail Widget', () {
    testWidgets('muestra loader cuando estado es ProductsLoading', (
      tester,
    ) async {
      // Arrange
      await pumpProductDetail(
        tester: tester,
        state: const ProductsLoading(),
      );

      // Act
      final loader = find.byKey(
        const Key('product_detail_loading_indicator'),
      );

      // Assert
      expect(loader, findsOneWidget);
    });

    testWidgets('renderiza la página cuando hay ProductDetailLoaded', (
      tester,
    ) async {
      // Arrange
      final product = createFakeProducts().first;
      await pumpProductDetail(
        tester: tester,
        state: ProductDetailLoaded(product),
      );

      // Act
      final detailPageFinder = find.byType(DSProductDetailPage);

      // Assert
      expect(detailPageFinder, findsOneWidget);
    });

    testWidgets('onBuyNow agrega al carrito y cambia nav index', (
      tester,
    ) async {
      // Arrange
      final product = createFakeProducts().first;
      await pumpProductDetail(
        tester: tester,
        state: ProductDetailLoaded(product),
      );

      final detailPage = tester.widget<DSProductDetailPage>(
        find.byType(DSProductDetailPage),
      );

      // Act
      detailPage.onBuyNow?.call();
      await tester.pump();

      // Assert
      expect(fakeCarItemsNotifier.state.length, 1);
      expect(fakeNavBarIndexNotifier.lastSetValue, 1);
    });
  });
}
