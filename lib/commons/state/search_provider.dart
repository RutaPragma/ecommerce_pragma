import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notificador de estado para la búsqueda global.
class SearchNotifier extends StateNotifier<String> {
  /// Crea un [SearchNotifier] con estado inicial vacío.
  SearchNotifier() : super('');

  /// Actualiza el query de búsqueda.
  void updateQuery(String query) => state = query;

  /// Limpia el query de búsqueda.
  void clear() => state = '';
}

/// Provider global para el estado de búsqueda.
final searchNotifierProvider = StateNotifierProvider<SearchNotifier, String>(
  (ref) => SearchNotifier(),
);
