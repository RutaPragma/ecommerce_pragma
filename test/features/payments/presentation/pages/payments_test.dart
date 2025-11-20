// test/features/payments/presentation/pages/payments_test.dart

import 'dart:io';

import 'package:ecommerce_pragma/commons/state/car_items_provider.dart';
import 'package:ecommerce_pragma/commons/state/localization_provider.dart';
import 'package:ecommerce_pragma/features/payments/presentation/pages/payments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

import '../../../../base_widget.dart';


void main() {
  late Override overrideLocalizationProvider;
  late Override overrideCarItemsProvider;
  late TestCarItemsNotifier testCarItemsNotifier;

  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    testCarItemsNotifier = TestCarItemsNotifier();
    overrideLocalizationProvider = localizationProvider.overrideWith(
      (ref) => FakeAppLocalizations(),
    );
    overrideCarItemsProvider = carItemsNotifierProvider.overrideWith(
      (ref) => testCarItemsNotifier,
    );
    addTearDown(() {
      HttpOverrides.global = null;
    });
  });

  /// Monta [Payments] con los providers y router sobrescritos.
  Future<GoRouter> pumpPayments(WidgetTester tester) async {
    final view = tester.view;
    final previousSize = view.physicalSize;
    final previousPixelRatio = view.devicePixelRatio;
    view.physicalSize = const Size(1440, 2560);
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.physicalSize = previousSize;
      view.devicePixelRatio = previousPixelRatio;
    });

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: '/payments',
          builder: (context, state) =>
              const Payments(total: '120', shipping: '10', subtotal: '110'),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [overrideLocalizationProvider, overrideCarItemsProvider],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
    router.push('/payments');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    return router;
  }

  group('Payments - UI rendering', () {
    testWidgets('Renderiza SafeArea, Material y DSCheckoutTemplate', (
      tester,
    ) async {
      // Arrange
      await pumpPayments(tester);

      // Act
      final safeAreaFinder = find.byKey(const Key('payments_safe_area'));
      final materialFinder = find.byKey(const Key('payments_material'));
      final templateFinder = find.byKey(
        const Key('payments_checkout_template'),
      );

      // Assert
      expect(safeAreaFinder, findsOneWidget);
      expect(materialFinder, findsOneWidget);
      expect(templateFinder, findsOneWidget);
    });
  });

  group('Payments - Callbacks', () {
    testWidgets('onAddressComplete muestra snackbar de confirmación', (
      tester,
    ) async {
      // Arrange
      await pumpPayments(tester);
      final templateFinder = find.byKey(
        const Key('payments_checkout_template'),
      );
      final checkoutTemplate = tester.widget<DSCheckoutTemplate>(
        templateFinder,
      );
      final onAddressComplete =
          checkoutTemplate.config['onAddressComplete']
              as void Function(Map<String, dynamic>);

      // Act
      onAddressComplete(<String, dynamic>{});
      await tester.pump();

      // Assert
      expect(
        find.byKey(const Key('payments_snackbar_address_text')),
        findsOneWidget,
      );
    });

    testWidgets('onCheckoutComplete reinicia carrito y muestra snackbar', (
      tester,
    ) async {
      // Arrange
      await pumpPayments(tester);
      final templateFinder = find.byKey(
        const Key('payments_checkout_template'),
      );
      final checkoutTemplate = tester.widget<DSCheckoutTemplate>(
        templateFinder,
      );
      final onCheckoutComplete =
          checkoutTemplate.config['onCheckoutComplete']
              as void Function(Map<String, dynamic>);

      // Act
      onCheckoutComplete(<String, dynamic>{});
      await tester.pump();

      // Assert
      expect(testCarItemsNotifier.resetCalled, isTrue);
      expect(
        find.byKey(const Key('payments_snackbar_order_text')),
        findsOneWidget,
      );
    });
  });
}
