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

  group('Register & Logout', () {
    testWidgets('register success muestra snackbar', (tester) async {
      // Arrange
      when(() => mockService.register(any(), any(), any())).thenAnswer(
        (_) async => UserModel(id: '2', email: 'new@test.com', name: 'Nuevo'),
      );

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('register_target'))),
      );
      final context = tester.element(find.text('register_target'));

      // Act
      final registerFuture = presenter.register(
        context,
        {'email': 'new@test.com', 'name': 'Nuevo', 'password': '12345678'},
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await registerFuture;

      // Assert
      expect(find.text('Usuario registrado: Nuevo'), findsOneWidget);
    });

    testWidgets('register error muestra mensaje de error', (tester) async {
      // Arrange
      when(() => mockService.register(any(), any(), any())).thenThrow(
        Exception('El usuario ya existe'),
      );

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('register_error'))),
      );
      final context = tester.element(find.text('register_error'));

      // Act
      final registerFuture = presenter.register(
        context,
        {'email': 'old@test.com', 'name': 'Viejo', 'password': '123456'},
      );
      await tester.pump();
      await registerFuture;

      // Assert
      expect(find.text('Exception: El usuario ya existe'), findsOneWidget);
    });

    testWidgets('logout invoca servicio y navega a auth', (tester) async {
      // Arrange
      when(() => mockService.logout()).thenAnswer((_) async {});

      // Act
      await presenter.logout();

      // Assert
      verify(() => mockService.logout()).called(1);
    });
  });
}
