import 'package:ecommerce_pragma/commons/state/state.dart';
import 'package:ecommerce_pragma/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../base_widget.dart';

/// Pruebas de la capa de presentación para [AuthPage].
void main() {
  late Override overrideLocalizationProvider;

  setUp(() {
    overrideLocalizationProvider = localizationProvider.overrideWith(
      (ref) => FakeAppLocalizations(),
    );
  });

  /// Monta [AuthPage] aplicando los overrides necesarios.
  Future<void> pumpAuthPage(
    WidgetTester tester, {
    Override? localizationOverride,
  }) async {
    await BaseWidget(
      child: const AuthPage(),
      overrides: [localizationOverride ?? overrideLocalizationProvider],
    ).mount(tester);
  }

  group('AuthPage - UI rendering', () {
    testWidgets('Muestra Material y DSAuthTemplate', (tester) async {
      // Arrange
      await pumpAuthPage(tester);

      // Act
      final materialFinder = find.byKey(const Key('auth_material'));
      final templateFinder = find.byKey(const Key('auth_template'));

      // Assert
      expect(materialFinder, findsOneWidget);
      expect(templateFinder, findsOneWidget);
    });

    testWidgets('Renderiza los botones sociales configurados', (tester) async {
      // Arrange
      await pumpAuthPage(tester);

      // Act
      final googleButton = find.byKey(const Key('auth_social_button_google'));
      final appleButton = find.byKey(const Key('auth_social_button_apple'));
      final googleLabel = find.text('Continuar con Google');

      // Assert
      expect(googleButton, findsOneWidget);
      expect(appleButton, findsOneWidget);
      expect(googleLabel, findsWidgets);
    });

    testWidgets(
      'No renderiza botones sociales cuando la configuración no los incluye',
      (tester) async {
        // Arrange
        final overrideWithoutSocialButtons = localizationProvider.overrideWith(
          (ref) => FakeAppLocalizationsNoSocial(),
        );

        await pumpAuthPage(
          tester,
          localizationOverride: overrideWithoutSocialButtons,
        );

        // Act
        final socialButtons = find.byKey(
          const Key('auth_social_button_google'),
        );

        // Assert
        expect(socialButtons, findsNothing);
      },
    );
  });
}

/// Localización falsa sin configuración de botones sociales.
class FakeAppLocalizationsNoSocial extends FakeAppLocalizations {
  @override
  Map<String, dynamic> get localizedStrings {
    final base = Map<String, dynamic>.from(super.localizedStrings);
    final authPageConfig = Map<String, dynamic>.from(
      base['auth_page'] as Map<String, dynamic>,
    );
    authPageConfig.remove('socialButtons');
    base['auth_page'] = authPageConfig;
    return base;
  }
}
