import 'package:ecommerce_pragma/commons/state/car_items_provider.dart';
import 'package:ecommerce_pragma/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

class Payments extends ConsumerWidget {
  const Payments({
    super.key,
    required this.total,
    required this.shipping,
    required this.subtotal,
  });

  final String total;
  final String shipping;
  final String subtotal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsCar = ref.watch(carItemsNotifierProvider);

    final AppLocalizations language = AppLocalizations.of(context);
    final Map<String, dynamic> config =
        language.localizedStrings['paymentWidget'];

    final List<Map<String, dynamic>> productsCart = itemsCar.map((product) {
      return {
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'badgeText': 'New',
        'badgeBackgroundColor': DSColorsFoundations.brandSecondaryDark,
        'badgeTextColor': Colors.black,
      };
    }).toList();

    config['itemsCar'] = itemsCar.length;
    config['orderSummary']['products'] = productsCart;
    config['orderSummary']['subtotal'] = subtotal;
    config['orderSummary']['shipping'] = shipping;
    config['orderSummary']['total'] = total;
    config['onAddressComplete'] = (data) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(config['alertMessage']['addressOk'])),
      );
    };
    config['onCheckoutComplete'] = (data) {
      ref.read(carItemsNotifierProvider.notifier).reset();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(config['alertMessage']['orderOk'])),
      );
      context.pop();
    };

    return SafeArea(child: DSCheckoutTemplate(config: config));
  }
}
