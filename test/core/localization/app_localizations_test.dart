import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_pragma/core/localization/app_localizations.dart';
import 'package:flutter/widgets.dart';

void main() {
  group('AppLocalizations', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('constructor asigna locale correctamente', () {
      // Arrange
      const locale = Locale('es');
      // Act
      final localizations = AppLocalizations(locale);
      // Assert
      expect(localizations.locale, locale);
    });

    test('load() carga correctamente el JSON de traducciones', () async {
      // Arrange
      const jsonString = '''{
        "auth": {"login": "Iniciar sesión", "register": "Registrarse"},
        "dashboard": {"title": "Dashboard"}
      }''';

      final localizations = AppLocalizations(const Locale('es'));

      // Act
      final loaded = await localizations.load(jsonTest: jsonString);

      // Assert
      expect(loaded, isTrue);
      expect(localizations.localizedStrings['auth']['login'], 'Iniciar sesión');
    });

    test(
      'translate retorna el valor correcto para una clave anidada',
      () async {
        // Arrange
        const jsonString = '''{
        "auth": {"login": "Iniciar sesión", "register": "Registrarse"},
        "dashboard": {"title": "Dashboard"}
      }''';

        final localizations = AppLocalizations(const Locale('es'));
        await localizations.load(jsonTest: jsonString);

        // Act
        final result = localizations.translate('auth.login');

        // Assert
        expect(result, 'Iniciar sesión');
      },
    );

    test('translate retorna key not found si la clave no existe', () async {
      // Arrange
      const jsonString = '''{
        "auth": {"login": "Iniciar sesión"}
      }''';

      final localizations = AppLocalizations(const Locale('es'));
      await localizations.load(jsonTest: jsonString);

      // Act
      final result = localizations.translate('auth.noexiste');

      // Assert
      expect(result, '** noexiste not found **');
    });

    test(
      'translate retorna key not found para clave raíz inexistente',
      () async {
        // Arrange
        const jsonString = '''{
        "auth": {"login": "Iniciar sesión"}
      }''';

        final localizations = AppLocalizations(const Locale('es'));
        await localizations.load(jsonTest: jsonString);

        // Act
        final result = localizations.translate('payments.title');

        // Assert
        expect(result, '** payments not found **');
      },
    );
  });
}
