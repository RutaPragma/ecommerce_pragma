import 'package:ecommerce_pragma/commons/state/car_items_provider.dart';
import 'package:ecommerce_pragma/commons/state/nav_bar_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:pragma_design_system/pragma_design_system.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/product_state.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/products_notifier.dart';

class ProductDetail extends ConsumerStatefulWidget {
  const ProductDetail({
    super.key,
    required this.productCode,
    required this.relateProducts,
    required this.productItem,
  });

  final int productCode;
  final List<Map<String, dynamic>> relateProducts;
  final ProductItem productItem;

  @override
  ConsumerState<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  late final ProductItem productItem;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final productsNotifier = ref.read(productsNotifierProvider.notifier);
      productsNotifier.loadProductById(widget.productCode);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productsNotifierProvider);
    final itemsCart = ref.watch(carItemsNotifierProvider);

    return SafeArea(
      child: switch (productState) {
        ProductsLoading() => const Center(child: CircularProgressIndicator()),

        ProductsListLoaded() => const Center(
          child: CircularProgressIndicator(),
        ),

        ProductDetailLoaded(:final product) => DSProductDetailPage(
          config: {
            'product': {
              'title': product.title,
              'price': '${product.price}',
              'imageUrl': product.image,
              'description': product.description,
              'rating': product.rating?.count ?? 0,
            },
            'relatedProducts': widget.relateProducts,
            'itemsCar': itemsCart.length,
          },
          imageBoxFit: BoxFit.scaleDown,
          onBuyNow: () {
            ref
                .watch(carItemsNotifierProvider.notifier)
                .addProduct(widget.productItem);
            ref.read(navBarIndexNotifierProvider.notifier).setValue(1);
            context.pop();
          },
          onAddToCart: () => ref
              .watch(carItemsNotifierProvider.notifier)
              .addProduct(widget.productItem),
        ),

        ProductsError() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
