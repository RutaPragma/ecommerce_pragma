import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notificador de estado para el índice de la barra de navegación inferior.
class NavBarIndexNotifier extends StateNotifier<int> {
  /// Crea un [NavBarIndexNotifier] con índice inicial en 0.
  NavBarIndexNotifier() : super(0);

  /// Cambia el valor del índice de la barra de navegación.
  void setValue(int newValue) => state = newValue;

  /// Reinicia el índice a 0.
  void reset() => state = 0;
}

/// Provider global para el índice de la barra de navegación.
final navBarIndexNotifierProvider =
    StateNotifierProvider<NavBarIndexNotifier, int>(
      (ref) => NavBarIndexNotifier(),
    );
