// test/features/auth/data/mock_auth_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_pragma/features/auth/data/mock_auth_service.dart';
import 'package:ecommerce_pragma/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('MockAuthService', () {
    late MockAuthService authService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      authService = MockAuthService();
      await Future.delayed(const Duration(milliseconds: 10));
    });

    test('login retorna usuario existente', () async {
      // Arrange
      const email = 'test@mail.com';
      const password = 'irrelevant';

      // Act
      final user = await authService.login(email, password);

      // Assert
      expect(user, isA<UserModel>());
      expect(user?.email, email);
    });

    test('login lanza excepción si usuario no existe', () async {
      // Arrange
      const email = 'noexiste@mail.com';
      const password = 'irrelevant';

      // Act & Assert
      expect(() => authService.login(email, password), throwsException);
    });

    test('register agrega un nuevo usuario', () async {
      // Arrange
      const email = 'nuevo@mail.com';
      const name = 'Nuevo';
      const password = '1234';

      // Act
      final user = await authService.register(email, name, password);

      // Assert
      expect(user.email, email);
      expect(user.name, name);
    });

    test('register lanza excepción si el usuario ya existe', () async {
      // Arrange
      const email = 'test@mail.com';
      const name = 'Usuario Demo';
      const password = 'irrelevant';

      // Act & Assert
      expect(
        () => authService.register(email, name, password),
        throwsException,
      );
    });
  });
}
