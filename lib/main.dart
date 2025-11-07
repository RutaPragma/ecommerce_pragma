/// Biblioteca principal para la aplicación de comercio electrónico Pragma.
/// Este archivo contiene el punto de entrada de la aplicación y la configuración inicial.

import 'package:ecommerce_pragma/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading_api_data_dart/core/core.dart';

/// Punto de entrada principal de la aplicación.
/// 
/// Inicializa las configuraciones necesarias como:
/// - Variables de entorno
/// - Configuración de la API
/// - Providers de estado
void main() async {
  await dotenv.load();

  final String baseUrl = dotenv.get('API_BASE_URL');
  final int connectTimeout = dotenv.getInt('CONNECTION_TIME_OUT');

  FakeStoreApiAppConfig().initialize(
    baseUrl: baseUrl,
    connectTimeout: connectTimeout,
  );
  AppLogger.info('App Ecommerce inicializada');
  runApp(const ProviderScope(child: MyApp()));
}
