import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

class CarItemsNotifier extends StateNotifier<Set<ProductItem>> {
  CarItemsNotifier() : super({});

  void addProduct(ProductItem product) {
    state = {...state, product}.toSet();
    log(state.toString());
  }

  void removeProduct(int idProduct) {
    state = state.where((item) => item.id != idProduct).toSet();
  }

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

  void reset() {
    state = {};
  }
}

final carItemsNotifierProvider =
    StateNotifierProvider<CarItemsNotifier, Set<ProductItem>>(
      (ref) => CarItemsNotifier(),
    );
