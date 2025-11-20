import 'dart:convert';

import 'package:ecommerce_pragma/commons/state/nav_bar_index_provider.dart';
import 'package:ecommerce_pragma/features/auth/auth.dart';
import 'package:ecommerce_pragma/features/dashboard/presentation/widgets/profile.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../base_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Map<String, dynamic> profileConfig;
  late FakeNavBarIndexNotifier navBarNotifier;

  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    final mockUser = UserModel(
      id: '1',
      email: 'profile@test.com',
      name: 'Profile User',
    );
    SharedPreferences.setMockInitialValues({
      'mock_users': [jsonEncode(mockUser.toJson())],
      'current_user': jsonEncode(mockUser.toJson()),
    });
    final baseConfig = FakeAppLocalizations().localizedStrings['dashboard']
        ['profileWidget'] as Map<String, dynamic>;
    profileConfig = jsonDecode(jsonEncode(baseConfig)) as Map<String, dynamic>;
    navBarNotifier = FakeNavBarIndexNotifier(initialIndex: 2);
    addTearDown(() {
      HttpOverrides.global = null;
    });
  });

  Future<void> pumpProfile(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          navBarIndexNotifierProvider.overrideWith((ref) => navBarNotifier),
        ],
        child: MaterialApp(home: Profile(config: profileConfig)),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
  }

  group('Profile Widget', () {
    testWidgets('muestra template tras cargar el usuario', (tester) async {
      // Arrange
      await pumpProfile(tester);

      // Act & Assert
      expect(find.byKey(const Key('profile_template')), findsOneWidget);
    });

    testWidgets('onLogout restablece el índice del navbar', (tester) async {
      // Arrange
      await pumpProfile(tester);
      final onLogout = profileConfig['onLogout'] as VoidCallback?;

      // Act
      onLogout?.call();

      // Assert
      expect(navBarNotifier.lastSetValue, equals(0));
    });
  });
}
