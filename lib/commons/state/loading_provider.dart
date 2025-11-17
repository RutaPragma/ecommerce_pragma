import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notificador de estado para el indicador de carga global.
class LoadingNotifier extends StateNotifier<bool> {
  /// Crea un [LoadingNotifier] con estado inicial en `false` (no cargando).
  LoadingNotifier() : super(false);

  /// Actualiza el estado de carga.
  void updateQuery(bool newValue) => state = newValue;

  /// Limpia el estado de carga (lo pone en `false`).
  void clear() => state = false;
}

/// Provider global para el estado de carga de la aplicación.
final loadingNotifierProvider = StateNotifierProvider<LoadingNotifier, bool>(
  (ref) => LoadingNotifier(),
);
