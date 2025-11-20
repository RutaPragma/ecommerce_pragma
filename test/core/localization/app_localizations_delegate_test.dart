// test/core/localization/app_localizations_delegate_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_pragma/core/localization/app_localizations_delegate.dart';
import 'package:ecommerce_pragma/core/localization/app_localizations.dart';
import 'package:flutter/widgets.dart';

void main() {
  group('AppLocalizationsDelegate', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('isSupported retorna true para locales soportadas', () {
      // Arrange
      const delegate = AppLocalizationsDelegate();
      const localeEs = Locale('es');
      const localeEn = Locale('en');

      // Act & Assert
      expect(delegate.isSupported(localeEs), isTrue);
      expect(delegate.isSupported(localeEn), isTrue);
    });

    test('isSupported retorna false para locales no soportadas', () {
      // Arrange
      const delegate = AppLocalizationsDelegate();
      const localeFr = Locale('fr');
      const localeDe = Locale('de');

      // Act & Assert
      expect(delegate.isSupported(localeFr), isFalse);
      expect(delegate.isSupported(localeDe), isFalse);
    });

    test('load() retorna AppLocalizations cargado correctamente', () async {
      // Arrange

      const delegate = AppLocalizationsDelegate();
      const locale = Locale('es');

      // Act
      final result = await delegate.load(locale);

      // Assert
      expect(result, isA<AppLocalizations>());
      expect(result.locale, locale);
    });

    test('shouldReload retorna false', () {
      // Arrange
      const delegate1 = AppLocalizationsDelegate();
      const delegate2 = AppLocalizationsDelegate();

      // Act
      final result = delegate1.shouldReload(delegate2);

      // Assert
      expect(result, isFalse);
    });
  });
}
