import 'package:ecommerce_pragma/commons/state/state.dart';
import 'package:ecommerce_pragma/features/auth/auth.dart';
import 'package:ecommerce_pragma/features/auth/presentation/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

import '../../../../custoMocks.dart';

/// Override del provider de localización para pruebas
final overrideLocalizationProvider = localizationProvider.overrideWith(
  (ref) => FakeLocalizations(),
);

void main() {
  late MockAuthPresenter mockPresenter;

  setUpAll(() {
    registerFallbackValue(Container());
  });

  setUp(() {
    mockPresenter = MockAuthPresenter();

    // Stub de los métodos
    when(() => mockPresenter.googleLogin()).thenAnswer((_) async {});
    when(() => mockPresenter.appleLogin()).thenAnswer((_) async {});
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        overrideLocalizationProvider,
        // Se reemplaza la creación del presenter
      ],
      child: const MaterialApp(home: AuthPage()),
    );
  }
}
