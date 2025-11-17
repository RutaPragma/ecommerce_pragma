import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

/// Notificador de estado para los productos agregados al carrito.
///
/// Permite agregar, eliminar y modificar la cantidad de productos en el carrito.
class CarItemsNotifier extends StateNotifier<Set<ProductItem>> {
  /// Crea un [CarItemsNotifier] con un carrito vacío.
  CarItemsNotifier() : super({});

  /// Agrega un producto al carrito.
  void addProduct(ProductItem product) {
    state = {...state, product}.toSet();
    log(state.toString());
  }

  /// Elimina un producto del carrito por su [idProduct].
  void removeProduct(int idProduct) {
    state = state.where((item) => item.id != idProduct).toSet();
  }

  /// Incrementa la cantidad de un producto en el carrito.
  void addAmount(int idProduct) {
    state = state
        .map((item) {
          if (item.id == idProduct) {
            final newAmount = item.amount + 1;
            if (newAmount <= 0) {
              return null;
            }
            return item.copyWith(amount: newAmount);
          }
          return item;
        })
        .whereType<ProductItem>()
        .toSet();
  }

  /// Decrementa la cantidad de un producto en el carrito.
  void deleteAmount(int idProduct) {
    state = state
        .map((item) {
          if (item.id == idProduct) {
            final newAmount = item.amount - 1;
            if (newAmount <= 0) {
              return null;
            }
            return item.copyWith(amount: newAmount);
          }
          return item;
        })
        .whereType<ProductItem>()
        .toSet();
  }

  /// Reinicia el carrito a vacío.
  void reset() {
    state = {};
  }
}

/// Provider global para acceder al estado del carrito de compras.
final carItemsNotifierProvider =
    StateNotifierProvider<CarItemsNotifier, Set<ProductItem>>(
      (ref) => CarItemsNotifier(),
    );
