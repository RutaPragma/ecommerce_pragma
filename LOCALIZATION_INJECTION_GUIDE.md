## Guía: Inyección de Dependencias para Localizaciones

En este proyecto, la instancia de `AppLocalizations` se inyecta como dependencia usando Riverpod, en lugar de obtenerla directamente del contexto mediante `AppLocalizations.of(context)`.

### ¿Por qué?

- ✅ **Desacoplamiento**: Los widgets no dependen directamente de `BuildContext` para obtener localizaciones.
- ✅ **Testabilidad**: Es fácil mockar/overridear `localizationProvider` en tests.
- ✅ **Consistencia**: Patrón uniforme en toda la aplicación.
- ✅ **Reactividad**: Cambios de idioma pueden ser capturados automáticamente por el sistema de Riverpod.

### Cómo usar en una nueva página

#### 1. Importa el provider
```dart
import 'package:ecommerce_pragma/commons/state/state.dart';
```

#### 2. Asegúrate de usar `ConsumerWidget` o `ConsumerStatefulWidget`
```dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tu código aquí
  }
}
```

#### 3. Obtén `AppLocalizations` desde el provider
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  /// Obtén AppLocalizations desde el provider inyectado
  final language = ref.watch(localizationProvider);
  
  /// Accede a las traducciones
  final config = language.localizedStrings['section_key'];
  
  return Scaffold(
    title: config['title'],
  );
}
```

### Ejemplo completo

```dart
import 'package:ecommerce_pragma/commons/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExamplePage extends ConsumerWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Obtén AppLocalizations desde el provider inyectado
    final language = ref.watch(localizationProvider);
    final config = language.localizedStrings['example_page'];

    return Scaffold(
      appBar: AppBar(title: Text(config['title'])),
      body: Center(
        child: Text(config['subtitle']),
      ),
    );
  }
}
```

### En tests

Cuando escribas tests para una página, override el provider:

```dart
testWidgets('ExamplePage muestra el título correcto', (tester) async {
  final mockLanguage = MockAppLocalizations();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        localizationProvider.overrideWithValue(mockLanguage),
      ],
      child: MaterialApp(
        home: const ExamplePage(),
      ),
    ),
  );

  expect(find.text('Expected Title'), findsOneWidget);
});
```

### Estructura de traducción

Las traducciones están en `assets/lang/{en,es}.json`:

```json
{
  "example_page": {
    "title": "My Page Title",
    "subtitle": "My Page Subtitle"
  }
}
```

Y se acceden así:

```dart
final title = language.localizedStrings['example_page']['title'];
// O
final title = language.translate('example_page.title');
```

---

**Nota**: El `LocalizationScope` wrapper se aplica automáticamente en `MyApp` (lib/app.dart), por lo que no necesitas hacer nada especial en tu página.
