import 'package:ecommerce_pragma/commons/state/state.dart';
import 'package:ecommerce_pragma/features/dashboard/presentation/helper/manager_products.dart';
import 'package:ecommerce_pragma/routes/routes.dart' show appRouter, PathRoutes;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pragma_design_system/pragma_design_system.dart';
import 'package:reading_api_data_dart/domain/entities/product_entities/product.dart';

class Products extends ConsumerStatefulWidget {
  Products({super.key, required this.config, required this.listProducts});
  List<Product> listProducts = [];
  final Map<String, dynamic> config;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsState();
}

class _ProductsState extends ConsumerState<Products> {
  Map<String, dynamic> config = {};
  List<Map<String, dynamic>> listProducts = [];
  List<Map<String, dynamic>> listProductsPromotions = [];
  ManagerProducts managerProducts = ManagerProducts();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectNavIndex = ref.watch(navBarIndexNotifierProvider);
    final itemsCar = ref.watch(carItemsNotifierProvider);

    final builder = Builder(
      builder: (context) {
        if (widget.listProducts.isEmpty) {
          return const SafeArea(
            bottom: false,
            child: Material(
              child: Center(
                child: DSLoader(size: 80, color: Colors.deepPurple),
              ),
            ),
          );
        } else {
          if (listProducts.isEmpty) {
            listProducts = managerProducts.getProducts(widget.listProducts);
            listProductsPromotions = managerProducts.getProductsPromotions(
              widget.listProducts,
            );
            config = managerProducts.getConfig(
              config: widget.config,
              productsProm: listProductsPromotions,
              productsList: listProducts,
            );
          }

          return SafeArea(
            bottom: false,
            child: DSHomeTemplate(
              selectIndex: selectNavIndex,
              boxFitImage: BoxFit.scaleDown,
              showImageTopSpacing: true,
              onAddPressed: (productItem) {
                ref
                    .watch(carItemsNotifierProvider.notifier)
                    .addProduct(productItem);
              },
              onTapPressed: (productItem) {
                appRouter.push(
                  PathRoutes.productDetail,
                  extra: <String, dynamic>{
                    'productId': productItem.id,
                    'relatedProducts': listProductsPromotions,
                    'itemsCar': itemsCar.length,
                    'productItem': productItem,
                  },
                );
              },
              onNavItemSelect: (index) {
                ref.read(navBarIndexNotifierProvider.notifier).setValue(index);
              },
              onSearch: (value) {
                ref.read(searchNotifierProvider.notifier).updateQuery(value);
                final query = ref.read(searchNotifierProvider);

                setState(() {
                  final List<Map<String, dynamic>> vals = managerProducts
                      .filterProducts(products: listProducts, query: query);

                  config = managerProducts.getConfig(
                    config: widget.config,
                    productsProm: listProductsPromotions,
                    productsList: vals,
                  );
                });
              },
              config: config,
            ),
          );
        }
      },
    );
    return builder;
  }
}
