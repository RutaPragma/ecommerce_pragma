import 'package:ecommerce_pragma/commons/state/car_items_provider.dart';
import 'package:ecommerce_pragma/commons/state/nav_bar_index_provider.dart';
import 'package:ecommerce_pragma/features/dashboard/presentation/helper/manager_products.dart';
import 'package:ecommerce_pragma/routes/path_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

class Cart extends ConsumerWidget {
  Cart({super.key, required this.config});
  final Map<String, dynamic> config;

  final double shipping = 3.0;
  final ManagerProducts managerProducts = ManagerProducts();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsCar = ref.watch(carItemsNotifierProvider);
    final Map<String, dynamic> cartReference = managerProducts.getCartProducts(
      itemsCar,
      0,
    );

    final double price = cartReference['price'];
    final total = price + shipping;

    config['products'] = cartReference['products'];
    config['summary'] = {
      'subtotal': price,
      'shipping': shipping,
      'total': total,
    };

    config['onCheckout'] = () => context.push(
      PathRoutes.payments,
      extra: {'subtotal': '$price', 'shipping': '$shipping', 'total': '$total'},
    );

    config['onContinueShopping'] = () =>
        ref.read(navBarIndexNotifierProvider.notifier).setValue(0);

    return SafeArea(
      key: const Key('cart_safe_area'),
      child: DSCartTemplate(
        key: const Key('cart_template'),
        config: config,
        onRemove: (id) {
          ref.read(carItemsNotifierProvider.notifier).deleteAmount(id);
        },
        onAdd: (id) {
          ref.read(carItemsNotifierProvider.notifier).addAmount(id);
        },
        onDelete: (id) {
          ref.read(carItemsNotifierProvider.notifier).removeProduct(id);
        },
      ),
    );
  }
}
