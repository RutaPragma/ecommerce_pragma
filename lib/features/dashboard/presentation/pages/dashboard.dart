import 'package:ecommerce_pragma/commons/commons.dart';
import 'package:ecommerce_pragma/core/localization/app_localizations.dart';
import 'package:ecommerce_pragma/features/dashboard/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:pragma_design_system/pragma_design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading_api_data_dart/domain/entities/product_entities/product.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/product_state.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/products_notifier.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  List<Product> listProducts = [];
  Map<String, dynamic> dashboardLang = {};

  @override
  void initState() {
    final productsNotifier = ref.read(productsNotifierProvider.notifier);
    productsNotifier.loadAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations language = AppLocalizations.of(context);
    dashboardLang = language.localizedStrings['dashboard'];
    final selectNavIndex = ref.watch(navBarIndexNotifierProvider);
    final state = ref.watch(productsNotifierProvider);
    final itemsCar = ref.watch(carItemsNotifierProvider);

    if (state is ProductsListLoaded) {
      listProducts = (state).products;
    }

    Widget content;

    switch (selectNavIndex) {
      case 0:
        content = Products(
          key: const Key('dashboard_products'),
          config: dashboardLang['productsWidget'],
          listProducts: listProducts,
        );
        break;
      case 1:
        content = Cart(
          key: const Key('dashboard_cart'),
          config: dashboardLang['cartWidget'],
        );
        break;
      case 2:
        content = Profile(
          key: const Key('dashboard_profile'),
          config: dashboardLang['profileWidget'],
        );
        break;
      default:
        content = Profile(
          key: const Key('dashboard_profile'),
          config: dashboardLang['profileWidget'],
        );
    }

    return Scaffold(
      key: const Key('dashboard_scaffold'),
      body: Stack(
        key: const Key('dashboard_stack'),
        children: [
          content,
          Positioned(
            key: const Key('dashboard_positioned_icons'),
            top: 15,
            right: 35,
            child: Row(
              key: const Key('dashboard_row_icons'),
              children: [
                DSIconCounter(
                  key: const Key('dashboard_icon_notification'),
                  iconSize: 20,
                  badgeSize: 14,
                  badgeTextSize: 8,
                  icon: Icons.notifications_none_rounded,
                  onTap: () => ref
                      .read(navBarIndexNotifierProvider.notifier)
                      .setValue(1),
                ),
                const SizedBox(width: 10),
                DSIconCounter(
                  key: const Key('dashboard_icon_cart'),
                  iconSize: 20,
                  badgeSize: 14,
                  badgeTextSize: 8,
                  icon: Icons.shopping_cart_outlined,
                  count: itemsCar.length,
                  onTap: () => ref
                      .read(navBarIndexNotifierProvider.notifier)
                      .setValue(1),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: DSBottomNav(
        key: const Key('dashboard_bottom_nav'),
        currentIndex: selectNavIndex,
        items: [
          DSBottomNavItem(
            icon: Icons.home_rounded,
            label: dashboardLang['menuWidget']['item1'],
          ),
          DSBottomNavItem(
            icon: Icons.shopping_cart,
            label: dashboardLang['menuWidget']['item2'],
            badgeCount: itemsCar.length,
          ),
          DSBottomNavItem(
            icon: Icons.person_rounded,
            label: dashboardLang['menuWidget']['item3'],
          ),
        ],
        onItemSelected: (int indexItem) {
          ref.read(navBarIndexNotifierProvider.notifier).setValue(indexItem);
        },
      ),
    );
  }
}
