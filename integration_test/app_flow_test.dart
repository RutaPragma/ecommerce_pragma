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
import 'package:integration_test/integration_test.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/product_state.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/products_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/base_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  group('Flujo integral de la app', () {
    testWidgets('Inicia en AuthPage mostrando el template', (tester) async {
      // Arrange
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Act
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Assert
      expect(find.byKey(const Key('auth_template')), findsOneWidget);
    });

    testWidgets('Navega a dashboard y llega a pagos', (tester) async {
      // Arrange
      final fakeProductsNotifier = FakeProductsNotifier()
        ..emitState(ProductsListLoaded(createFakeProducts(count: 3)));
      final fakeCarItemsNotifier = FakeCarItemsNotifier(initialItems: {});
      final fakeNavBarNotifier = FakeNavBarIndexNotifier();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productsNotifierProvider.overrideWith(
              (ref) => fakeProductsNotifier,
            ),
            carItemsNotifierProvider.overrideWith(
              (ref) => fakeCarItemsNotifier,
            ),
            navBarIndexNotifierProvider.overrideWith(
              (ref) => fakeNavBarNotifier,
            ),
            searchNotifierProvider.overrideWith((ref) => SearchNotifier()),
          ],
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Act: ir al dashboard y validar productos.
      appRouter.go(PathRoutes.dashboard);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byKey(const Key('dashboard_products')), findsOneWidget);

      // Act: cambiar al carrito mediante el menú inferior.
      await tester.tap(find.text('Carro'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byKey(const Key('dashboard_cart')), findsOneWidget);

      // Act: navegar al flujo de pagos.
      appRouter.go(
        PathRoutes.payments,
        extra: {'subtotal': '25', 'shipping': '5', 'total': '30'},
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Assert
      expect(
        find.byKey(const Key('payments_checkout_template')),
        findsOneWidget,
      );
    });
  });
}
