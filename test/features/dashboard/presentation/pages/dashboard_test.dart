// test/features/dashboard/presentation/pages/dashboard_test.dart
import 'dart:io';

import 'package:ecommerce_pragma/commons/state/car_items_provider.dart';
import 'package:ecommerce_pragma/commons/state/localization_provider.dart';
import 'package:ecommerce_pragma/commons/state/nav_bar_index_provider.dart';
import 'package:ecommerce_pragma/features/dashboard/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/product_state.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/products_notifier.dart';

import '../../../../base_widget.dart';
import '../../../../custoMocks.dart';

void main() {
  late Override overrideLocalizationProvider;
  late Override overrideProductsNotifierProvider;
  late Override overrideNavBarIndexNotifierProvider;
  late Override overrideCarItemsNotifierProvider;
  late FakeProductsNotifier fakeProductsNotifier;
  late FakeNavBarIndexNotifier fakeNavBarIndexNotifier;
  late FakeCarItemsNotifier fakeCarItemsNotifier;
  late FakeAppLocalizations mockLocalizations;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeProduct());
    mockLocalizations = FakeAppLocalizations();
    overrideLocalizationProvider = localizationProvider.overrideWith(
      (ref) => mockLocalizations,
    );
  });

  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    addTearDown(() {
      HttpOverrides.global = null;
    });
    fakeProductsNotifier = FakeProductsNotifier();
    fakeNavBarIndexNotifier = FakeNavBarIndexNotifier();
    fakeCarItemsNotifier = FakeCarItemsNotifier();

    overrideProductsNotifierProvider = productsNotifierProvider.overrideWith(
      (ref) => fakeProductsNotifier,
    );

    overrideCarItemsNotifierProvider = carItemsNotifierProvider.overrideWith(
      (ref) => fakeCarItemsNotifier,
    );

    overrideNavBarIndexNotifierProvider = navBarIndexNotifierProvider
        .overrideWith((ref) => fakeNavBarIndexNotifier);
  });

  Future<void> pumpDashboard(WidgetTester tester) async {
    await BaseWidget(
      child: const Dashboard(),
      overrides: [
        overrideLocalizationProvider,
        overrideProductsNotifierProvider,
        overrideCarItemsNotifierProvider,
        overrideNavBarIndexNotifierProvider,
      ],
      shouldPumpAndSettle: false,
    ).mount(tester);
  }

  testWidgets('Dashboard renderiza estructura base', (tester) async {
    await pumpDashboard(tester);

    expect(find.byKey(const Key('dashboard_scaffold')), findsOneWidget);
    expect(fakeProductsNotifier.loadAllProductsCalled, isTrue);
  });

  testWidgets('Dashboard muestra Products y contenido cargado cuando nav = 0', (
    tester,
  ) async {
    fakeProductsNotifier.emitState(
      ProductsListLoaded(createFakeProducts(count: 2)),
    );

    await pumpDashboard(tester);

    expect(find.byKey(const Key('dashboard_products')), findsOneWidget);
    expect(find.byKey(const Key('products_home_template')), findsOneWidget);
  });

  testWidgets('Dashboard muestra Cart cuando nav = 1', (tester) async {
    fakeNavBarIndexNotifier.setInitialIndex(1);

    await pumpDashboard(tester);

    expect(find.byKey(const Key('dashboard_cart')), findsOneWidget);
  });

  testWidgets('Dashboard muestra Profile cuando nav = 2', (tester) async {
    fakeNavBarIndexNotifier.setInitialIndex(2);

    await pumpDashboard(tester);

    expect(find.byKey(const Key('dashboard_profile')), findsOneWidget);
  });

  testWidgets('Tocar icono de carrito solicita nav index = 1', (tester) async {
    await pumpDashboard(tester);

    await tester.tap(find.byKey(const Key('dashboard_icon_cart')));
    await tester.pumpAndSettle();

    expect(fakeNavBarIndexNotifier.lastSetValue, equals(1));
  });

  testWidgets('Seleccionar Perfil en el bottom nav cambia el índice', (
    tester,
  ) async {
    await pumpDashboard(tester);

    await tester.tap(find.text('Perfil'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(fakeNavBarIndexNotifier.lastSetValue, equals(2));
  });
}
