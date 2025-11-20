import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_pragma/commons/state/car_items_provider.dart';
import 'package:ecommerce_pragma/commons/state/nav_bar_index_provider.dart';
import 'package:ecommerce_pragma/features/dashboard/presentation/widgets/cart.dart';
import 'package:ecommerce_pragma/routes/path_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

import '../../../../base_widget.dart';

void main() {
  late Map<String, dynamic> cartConfig;
  late _TrackingCarItemsNotifier cartNotifier;
  late FakeNavBarIndexNotifier navBarNotifier;

  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    final baseConfig = FakeAppLocalizations().localizedStrings['dashboard']
        ['cartWidget'] as Map<String, dynamic>;
    cartConfig = jsonDecode(jsonEncode(baseConfig)) as Map<String, dynamic>;
    cartNotifier = _TrackingCarItemsNotifier();
    navBarNotifier = FakeNavBarIndexNotifier(initialIndex: 1);
    addTearDown(() {
      HttpOverrides.global = null;
    });
  });

  Future<void> pumpCart(WidgetTester tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (context, state) => Cart(config: cartConfig),
        ),
        GoRoute(
          path: PathRoutes.payments,
          builder: (context, state) => const Scaffold(
            body: Text('payments_page'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          carItemsNotifierProvider.overrideWith((ref) => cartNotifier),
          navBarIndexNotifierProvider.overrideWith((ref) => navBarNotifier),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
  }

  group('Cart Widget', () {
    testWidgets('renderiza SafeArea y template', (tester) async {
      // Arrange
      await pumpCart(tester);

      // Act & Assert
      expect(find.byKey(const Key('cart_safe_area')), findsOneWidget);
      expect(find.byKey(const Key('cart_template')), findsOneWidget);
    });

    testWidgets('callbacks de template modifican el carrito', (tester) async {
      // Arrange
      await pumpCart(tester);
      final template = tester.widget<DSCartTemplate>(
        find.byKey(const Key('cart_template')),
      );

      // Act
      template.onAdd?.call(1);
      template.onRemove?.call(1);
      template.onDelete?.call(2);

      // Assert
      expect(cartNotifier.addCalledWith, contains(1));
      expect(cartNotifier.removeCalledWith, contains(1));
      expect(cartNotifier.deleteCalledWith, contains(2));
    });

    testWidgets('onContinueShopping restablece nav bar', (tester) async {
      // Arrange
      await pumpCart(tester);
      final onContinue =
          cartConfig['onContinueShopping'] as VoidCallback?;

      // Act
      onContinue?.call();

      // Assert
      expect(navBarNotifier.lastSetValue, equals(0));
    });

    testWidgets('onCheckout navega a la pantalla de pagos', (tester) async {
      // Arrange
      await pumpCart(tester);
      final onCheckout = cartConfig['onCheckout'] as VoidCallback?;

      // Act
      onCheckout?.call();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('payments_page'), findsOneWidget);
    });
  });
}

class _TrackingCarItemsNotifier extends CarItemsNotifier {
  _TrackingCarItemsNotifier() {
    state = {
      ProductItemMock.create(id: 1),
      ProductItemMock.create(id: 2),
    };
  }

  final List<int> addCalledWith = [];
  final List<int> removeCalledWith = [];
  final List<int> deleteCalledWith = [];

  @override
  void addAmount(int idProduct) {
    addCalledWith.add(idProduct);
    super.addAmount(idProduct);
  }

  @override
  void deleteAmount(int idProduct) {
    removeCalledWith.add(idProduct);
    super.deleteAmount(idProduct);
  }

  @override
  void removeProduct(int idProduct) {
    deleteCalledWith.add(idProduct);
    super.removeProduct(idProduct);
  }
}
