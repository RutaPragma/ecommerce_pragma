// test/features/auth/presenter/auth_presenter_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_pragma/features/auth/presenter/ auth_presenter.dart';

void main() {
  group('AuthPresenter', () {
    late AuthPresenter presenter;

    setUp(() {
      presenter = AuthPresenter();
    });

    test('constructor crea una instancia de AuthPresenter', () {
      // Arrange & Act
      final result = presenter;

      // Assert
      expect(result, isA<AuthPresenter>());
    });

    test('googleLogin es un método callable', () {
      // Arrange & Act
      final result = presenter.googleLogin;

      // Assert
      expect(result, isA<Function>());
    });

    test('appleLogin es un método callable', () {
      // Arrange & Act
      final result = presenter.appleLogin;

      // Assert
      expect(result, isA<Function>());
    });

    // NOTA: Los métodos login, register, logout y getCurrentUser requieren
    // inyección de dependencias o mocking de MockAuthService y contexto,
    // lo cual se recomienda para tests de integración más adelante.
  });
}
