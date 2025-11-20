# Guía de testing y cobertura

Esta guía documenta cómo generar el informe de cobertura con lcov y describe las pruebas existentes, su implementación y las decisiones de diseño tomadas.

## Cobertura con lcov
- **Prerequisitos**: tener `lcov` instalado (incluye `genhtml`). En macOS se puede instalar con `brew install lcov`.
- **Aplicación Flutter**:
  1. Limpiar resultados previos: `rm -rf coverage`.
  2. Ejecutar todo el suite unificado: `flutter test test/main.dart --coverage`. Esto genera `coverage/lcov.info` a partir de todos los módulos agregados en `test/main.dart`.
  3. (Opcional) Validar desde la terminal: `lcov --list coverage/lcov.info`.
  4. Generar reporte HTML: `genhtml coverage/lcov.info -o coverage/html`.
  5. Abrir el reporte: `open coverage/html/index.html`.
- **Paquetes Flutter locales**:
  - Si se añaden paquetes en `packages/<nombre>`, desde la raíz de cada paquete ejecutar `flutter test --coverage` (o `flutter test test/main.dart --coverage` si replica el agregador). Se generará `packages/<nombre>/coverage/lcov.info`.
  - Para consolidar varias trazas en un solo reporte global:  
    `lcov --add-tracefile coverage/lcov.info --add-tracefile packages/<nombre>/coverage/lcov.info --output-file coverage/combined.info`  
    Luego `genhtml coverage/combined.info -o coverage/html` y abrir el índice como en el paso 5.
- **Notas**:
  - El agregador `test/main.dart` garantiza que se incluyan todas las suites por capa/feature y mantiene la jerarquía definida en `.github/openai-instructions.md`.
  - Los reportes viven en `coverage/html`; eliminar la carpeta antes de regenerar evita arrastrar resultados antiguos.
- **Ejemplo de reporte HTML**:
  - Una vez generado el reporte, el resumen se ve así:

    ![Reporte de cobertura](/assets/docs/coverage.png)

## Detalle de las pruebas existentes
- **Orquestación de suites**: `test/main.dart` ejecuta `commons`, `core`, `features` (auth, dashboard, payments, product, splash) y `routes`. Cada módulo expone su propio `main_*.dart` para mantener la estructura jerárquica de Clean Architecture.
- **Infra de testing**:
  - `test/base_widget.dart` centraliza utilitarios: `BaseWidget` monta `ProviderScope` para tests de UI, `FakeAppLocalizations` elimina dependencias de assets, `HttpOverrides` inyecta una imagen transparente y mocks/fakes de notifiers para evitar IO real.
  - Se usa `mocktail` para simular servicios (p. ej. autenticación) y `ProviderScope.overrideWith` para reemplazar notifiers al probar interacciones de UI sin hitting la red.
- **Commons/State**:
  - `car_items_provider_test.dart` cubre alta/baja de productos, incremento/decremento, reseteo y eliminación en border cases (`amount <= 0`).
  - `nav_bar_index_provider_test.dart`, `search_provider_test.dart`, `loading_provider_test.dart` y `theme_provider_test.dart` validan estados iniciales y transiciones (toggle de temas, limpieza de búsqueda, etc.).
  - `localization_provider_test.dart` asegura que el provider cargue/traduzca textos usando los fakes.
- **Core**:
  - `core/localization/*_test.dart` verifica `AppLocalizations` (carga de JSON, traducciones anidadas, manejo de claves inexistentes) y `AppLocalizationsDelegate` (locales soportadas, carga y `shouldReload`).
  - `core/helper/app_navigator_test.dart` confirma el singleton y la disponibilidad de operaciones `go/push/pop` sobre el router global.
- **Rutas e integración**:
  - `routes/app_router_test.dart` monta `MyApp` con providers falsos, navega a detalle de producto y pagos usando `GoRouter` y valida que las páginas clave se rendericen.
  - `integration_test/app_flow_test.dart` recorre el flujo completo: arranca en `AuthPage`, navega a dashboard con productos, pasa por carrito y llega a pagos, reusando overrides para evitar dependencias externas.
- **Features**:
  - **Auth**: `data/mock_auth_service_test.dart` garantiza respuestas controladas del servicio simulado; `presenter/auth_presenter_test.dart` cubre login (éxito/error y snackbars), registro (mensajes de éxito/error) y logout; `presentation/pages/auth_page_test.dart` valida renderizado del template DS, botones sociales condicionados por localización y uso del provider de traducciones.
  - **Dashboard**: tests de widgets (`products_test.dart`, `cart_test.dart`, `profile_test.dart`, `dashboard_test.dart`) confirman que el menú inferior cambia de vista, el carrito muestra resúmenes y acciones, y los listados de productos se muestran con estados de carga simulados.
  - **Product**: `product_detail_test.dart` comprueba estados de carga vs detalle, y que `onBuyNow` agrega al carrito y mueve la barra inferior al tab de carrito.
  - **Payments**: `payments_test.dart` valida la estructura UI (SafeArea/Material/DSCheckoutTemplate) y callbacks `onAddressComplete`/`onCheckoutComplete`, incluyendo el reseteo del carrito y snackbars de confirmación.
  - **Splash**: pruebas de presentación verifican que la pantalla inicial renderice con las llaves esperadas antes de la navegación.

## Decisiones clave durante la implementación
- Los tests de UI usan `GoRouter` local o el `appRouter` global según corresponda, siempre inyectando `ProviderScope` con overrides para aislar efectos secundarios.
- `HttpOverrides` y `SharedPreferences.setMockInitialValues` evitan IO real y permiten tests deterministas sin red ni disco.
- Se priorizó el patrón AAA en todos los tests y la separación por capas (data/presenter/presentation) para alinear la cobertura con la arquitectura limpia del proyecto.
- Los fakes de localización permiten probar textos sin depender de assets ni del pipeline de intl, manteniendo el feedback rápido al desarrollar.
