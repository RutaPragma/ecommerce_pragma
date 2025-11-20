import 'dart:convert';

import 'package:ecommerce_pragma/commons/state/localization_provider.dart';
import 'package:ecommerce_pragma/core/localization/app_localizations.dart';
import 'package:ecommerce_pragma/core/localization/localization_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('localizationProvider', () {
    test('debe lanzar si no se override', () {
      // Arrange
      final container = ProviderContainer();

      // Act & Assert
      expect(
        () => container.read(localizationProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });

    testWidgets('LocalizationScope expone AppLocalizations vía providers', (
      tester,
    ) async {
      // Arrange
      AppLocalizations? providerValue;
      AppLocalizations? familyValue;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('es'),
            localizationsDelegates: const [
              _TestDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [Locale('es')],
            home: LocalizationScope(
              child: Consumer(
                builder: (context, ref, _) {
                  providerValue = ref.watch(localizationProvider);
                  familyValue =
                      ref.watch(localizationFamilyProvider(context));
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(providerValue?.locale, const Locale('es'));
      expect(familyValue?.locale, const Locale('es'));
    });

    testWidgets(
      'LocalizationScope retorna child cuando no hay localizaciones',
      (tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: LocalizationScope(
              child: Placeholder(key: Key('scope_child')),
            ),
          ),
        );

        // Act & Assert
        expect(find.byKey(const Key('scope_child')), findsOneWidget);
      },
    );
  });
}

class _TestDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _TestDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final appLocalizations = AppLocalizations(locale);
    await appLocalizations.load(jsonTest: jsonEncode({'home': 'Inicio'}));
    return appLocalizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
