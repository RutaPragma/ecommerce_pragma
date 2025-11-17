// test/features/auth/presentation/pages/auth_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_pragma/features/auth/presentation/pages/auth_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('AuthPage Widget', () {
    testWidgets('debe renderizar el widget principal', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: AuthPage())),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(const Key('auth_material')), findsOneWidget);
      expect(find.byKey(const Key('auth_template')), findsOneWidget);
    });
  });
}
