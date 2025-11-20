import 'package:ecommerce_pragma/core/helper/app_navigator.dart';
import 'package:ecommerce_pragma/routes/path_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppNavigator', () {
    test('debe ser singleton', () {
      // Arrange & Act
      final nav1 = AppNavigator();
      final nav2 = AppNavigator();
      // Assert
      expect(identical(nav1, nav2), isTrue);
    });

    // NOTA: Los métodos go, push y pop dependen de appRouter global,
    // por lo que para un test real se requeriría inyectar o mockear appRouter.
    // Aquí solo se valida la existencia de los métodos.
    test('debe exponer métodos go, push y pop', () {
      // Arrange
      final nav = AppNavigator();
      // Assert
      expect(nav.go, isA<Function>());
      expect(nav.push, isA<Function>());
      expect(nav.pop, isA<Function>());
    });

    test('go y push llaman al router global sin lanzar errores', () {
      // Arrange
      final nav = AppNavigator();

      // Act & Assert
      expect(() => nav.go(PathRoutes.auth), returnsNormally);
      expect(() => nav.push(PathRoutes.dashboard), returnsNormally);
    });

  });
}
