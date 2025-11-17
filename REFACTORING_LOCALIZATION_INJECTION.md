# Refactorización: Inyección de Dependencias para Localizaciones

## Resumen

Se ha refactorizado la arquitectura de localizaciones en el proyecto para usar **inyección de dependencias con Riverpod** en lugar de obtener `AppLocalizations` directamente del contexto.

## Cambios Realizados

### 1. **Nuevo Provider** - `localizationProvider`
📁 **Archivo**: `lib/commons/state/localization_provider.dart`

```dart
final localizationProvider = Provider<AppLocalizations>((ref) {
  throw UnimplementedError(...);
});
```

- Provider Riverpod que proporciona `AppLocalizations`.
- Debe ser overrideado con la instancia del contexto.
- Incluye una variante `localizationFamilyProvider` para casos específicos.

### 2. **Nuevo Widget Scope** - `LocalizationScope`
📁 **Archivo**: `lib/core/localization/localization_scope.dart`

```dart
class LocalizationScope extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    return ProviderScope(
      overrides: [
        localizationProvider.overrideWithValue(appLocalizations),
      ],
      child: child,
    );
  }
}
```

- Wrapper que captura `AppLocalizations` del contexto.
- Lo proporciona como override del provider para todos los widgets descendientes.

### 3. **App Mejorada** - `lib/app.dart`

```dart
@override
Widget build(BuildContext context) {
  final router = MaterialApp.router(...);
  
  return LocalizationScope(
    child: router,
  );
}
```

- `MyApp` ahora envuelve el `MaterialApp.router` con `LocalizationScope`.
- Esto permite que todos los widgets Consumer accedan a `localizationProvider`.

### 4. **Páginas Actualizadas**

#### ✅ **AuthPage** - `lib/features/auth/presentation/pages/auth_page.dart`
```dart
// ANTES
final language = AppLocalizations.of(context);

// DESPUÉS
final language = ref.watch(localizationProvider);
```

#### ✅ **Dashboard** - `lib/features/dashboard/presentation/pages/dashboard.dart`
```dart
// ANTES
final AppLocalizations language = AppLocalizations.of(context);

// DESPUÉS
final language = ref.watch(localizationProvider);
```

#### ✅ **Payments** - `lib/features/payments/presentation/pages/payments.dart`
```dart
// ANTES
final AppLocalizations language = AppLocalizations.of(context);

// DESPUÉS
final language = ref.watch(localizationProvider);
```

### 5. **Exportaciones Actualizadas**

- `lib/commons/state/state.dart` - Exporta `localization_provider.dart`
- `lib/core/localization/localization.dart` - Exporta `localization_scope.dart`

## Ventajas

| Ventaja | Descripción |
|---------|------------|
| **Desacoplamiento** | Widgets no dependen de `BuildContext` para localizaciones |
| **Testabilidad** | Fácil de mockar/overridear en tests |
| **Consistencia** | Patrón uniforme en toda la aplicación |
| **Reactividad** | Cambios de idioma pueden capturarse automáticamente |
| **Escalabilidad** | Fácil de extender a nuevas páginas |

## Cómo usar en nuevas páginas

### Opción 1: ConsumerWidget
```dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(localizationProvider);
    final config = language.localizedStrings['my_page'];
    
    return Scaffold(title: Text(config['title']));
  }
}
```

### Opción 2: ConsumerStatefulWidget
```dart
class MyPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  Widget build(BuildContext context) {
    final language = ref.watch(localizationProvider);
    return Scaffold(title: Text(language.translate('my_page.title')));
  }
}
```

## Testing

En tests, override el provider:

```dart
testWidgets('MyPage muestra el título', (tester) async {
  final mockLanguage = MockAppLocalizations();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        localizationProvider.overrideWithValue(mockLanguage),
      ],
      child: MaterialApp(home: const MyPage()),
    ),
  );

  expect(find.text('Expected Title'), findsOneWidget);
});
```

## Notas Importantes

⚠️ **Asegúrate de que**:
- Las páginas heredan de `ConsumerWidget` o `ConsumerStatefulWidget`.
- La aplicación está envuelta con `LocalizationScope` (ya hecho en `MyApp`).
- Los providers están importados correctamente desde `commons/state/state.dart`.

✅ **Ya está hecho**:
- `LocalizationScope` envuelve toda la aplicación.
- Todas las páginas principales están refactorizadas.
- Los imports están limpios y bien documentados.

## Documentación de Referencia

📖 Ver: `LOCALIZATION_INJECTION_GUIDE.md` para ejemplos detallados y patrones de uso.
