// test/features/splash/presentation/splash_page_test.dart

import 'package:ecommerce_pragma/features/splash/presentation/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Pruebas que validan la UI del splash.
void main() {
  group('SplashPage Widget', () {
    testWidgets('renderiza SafeArea y AnimatedSplash', (tester) async {
      // Arrange
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SplashPage(),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );

      // Act
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Assert
      expect(find.byKey(const Key('splash_safe_area')), findsOneWidget);
      expect(find.byKey(const Key('splash_animated')), findsOneWidget);
    });
  });
}
