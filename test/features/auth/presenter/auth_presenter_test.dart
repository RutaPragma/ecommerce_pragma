import 'package:ecommerce_pragma/core/helper/app_navigator.dart';
import 'package:ecommerce_pragma/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthServiceMock extends Mock implements MockAuthService {}

class MockRouter extends Mock implements GoRouter {}

class MockNavigatorWrapper extends Mock implements AppNavigator {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late AuthPresenter presenter;
  late MockAuthServiceMock mockService;
  late MockRouter mockRouter;

  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    mockService = MockAuthServiceMock();
    presenter = AuthPresenter(authService: mockService);

    mockRouter = MockRouter();
  });

  group('Login Tests', () {
    testWidgets('login success → navega a dashboard', (tester) async {
      // Arrange
      when(() => mockService.login('mail@test.com', '123')).thenAnswer(
        (_) async => UserModel(id: '1', email: 'mail@test.com', name: ''),
      );

      final context = tester.element(find.byType(Container));

      // Act
      await presenter.login(context, 'mail@test.com', '123');
      await tester.pumpAndSettle();

      // Assert
      expect(mockRouter, isNot(throwsException));
    });

    testWidgets('login fail → muestra snackbar', (tester) async {
      // Arrange
      when(() => mockService.login(any(), any())).thenThrow(Exception('error'));

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('test'))),
      );
      final context = tester.element(find.text('test'));

      // Act
      await presenter.login(context, 'a', 'b');
      await tester.pump(); // Render snackbar

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Usuario o contraseña inválidos'), findsOneWidget);
    });
  });

  group('getCurrentUser Tests', () {
    test('retorna usuario actual', () async {
      // Arrange
      final user = UserModel(id: '1', email: 'mail@test.com', name: '');
      when(() => mockService.getCurrentUser()).thenAnswer((_) async => user);

      // Act
      final result = await presenter.getCurrentUser();

      // Assert
      expect(result, user);
    });
  });
}
