# Ecommerce Pragma

Este es un proyecto de comercio electrónico desarrollado con Flutter, siguiendo las mejores prácticas de desarrollo y arquitectura limpia.

## Descripción

Una aplicación de comercio electrónico que implementa funcionalidades modernas y una arquitectura escalable. El proyecto utiliza el patrón de gestión de estado Riverpod y sigue una estructura modular para mejor mantenibilidad.

## Características

- Soporte multiidioma (Español e Inglés)
- Tema claro y oscuro
- Autenticación de usuarios
- Gestión de productos
- Sistema de pagos
- Diseño responsive
- Gestión de estado con Riverpod

## Estructura del Proyecto

```
lib/
├── app.dart                # Configuración principal de la aplicación
├── main.dart              # Punto de entrada de la aplicación
├── commons/              # Componentes y utilidades comunes
├── core/                # Funcionalidades centrales
│   ├── helper/          # Funciones auxiliares
│   └── localization/    # Manejo de internacionalización
├── features/            # Módulos principales de la aplicación
│   ├── auth/           # Autenticación
│   ├── dashboard/      # Panel principal
│   ├── payments/       # Sistema de pagos
│   ├── product/        # Gestión de productos
│   └── splash/         # Pantalla de inicio
└── routes/             # Configuración de navegación
```

## Requisitos Técnicos

- Flutter (última versión estable)
- Dart SDK
- API Base URL configurada en variables de entorno
- Dispositivo o emulador iOS/Android

## Configuración del Proyecto

1. Clonar el repositorio:
```bash
git clone https://github.com/RutaPragma/ecommerce_pragma.git
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Configurar variables de entorno:
Crear un archivo `.env` en la raíz del proyecto, puedes basarte en el archivo de ejemplo: `.env.template` 

4. Ejecutar la aplicación:
```bash
flutter run
```

## Arquitectura

El proyecto sigue una arquitectura limpia (Clean Architecture) con las siguientes capas:

- **Presentación**: Widgets y páginas de UI
- **Lógica de Negocio**: Providers y casos de uso
- **Datos**: Repositorios y fuentes de datos
- **Core**: Utilidades y configuraciones base

## Paquetes Principales

- `flutter_riverpod`: Gestión de estado
- `flutter_dotenv`: Manejo de variables de entorno
- `pragma_design_system`: Sistema de diseño personalizado
- `reading_api_data_dart`: Paquete para lectura de datos de API
- `flutter_localizations`: Soporte para múltiples idiomas

## Convenciones de Código

- Seguimos las convenciones de estilo de Dart/Flutter
- Utilizamos análisis estático con `analysis_options.yaml`
- Implementamos pruebas unitarias y de widgets

## Internacionalización

La aplicación soporta múltiples idiomas a través de archivos JSON localizados en:
```
assets/lang/
├── en.json    # Inglés
└── es.json    # Español
```

## Temas

La aplicación implementa temas claro y oscuro utilizando el sistema de diseño Pragma:
- Light Theme: Tema predeterminado para uso diurno
- Dark Theme: Tema optimizado para uso nocturno




## Run tests

#### Unitarios
```
flutter test test/main.dart --coverage &&
genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html
```

También puedes ejecutar el comando individual:
```
flutter test test/main.dart --coverage
```

#### Integración

Para ejecutar los tests de integración (requiere un dispositivo/emulador conectado):
```
flutter test integration_test/app_flow_test.dart -d <device_id>
```
