// test/features/auth/models/user_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_pragma/features/auth/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson y toJson deben ser inversos', () {
      // Arrange
      final json = {'id': '123', 'email': 'test@mail.com', 'name': 'Test User'};

      // Act
      final user = UserModel.fromJson(json);
      final result = user.toJson();

      // Assert
      expect(result, equals(json));
    });

    test('constructor debe asignar correctamente los campos', () {
      // Arrange
      const id = '1';
      const email = 'a@b.com';
      const name = 'Nombre';

      // Act
      final user = UserModel(id: id, email: email, name: name);

      // Assert
      expect(user.id, id);
      expect(user.email, email);
      expect(user.name, name);
    });
  });
}
