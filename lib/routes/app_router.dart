/// Configuración de rutas para la aplicación de comercio electrónico.
///
/// Este archivo define todas las rutas disponibles en la aplicación y
/// sus respectivas transiciones y configuraciones.

import 'package:ecommerce_pragma/features/features.dart';
import 'package:ecommerce_pragma/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

/// Configuración principal del router de la aplicación.
///
/// Utiliza [GoRouter] para manejar la navegación y define:
/// - Ruta inicial
/// - Transiciones personalizadas
/// - Paso de parámetros entre rutas
/// - Animaciones de navegación
final GoRouter appRouter = GoRouter(
  initialLocation: PathRoutes.auth,
  routes: [
    GoRoute(
      path: PathRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: PathRoutes.auth,
      name: 'auth',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: PathRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const Dashboard(),
    ),

    GoRoute(
      path: PathRoutes.productDetail,
      name: 'product_detail',
      pageBuilder: (context, state) {
        final Map<String, dynamic>? extra =
            state.extra as Map<String, dynamic>?;
        final int productCode = (extra?['productId'] is int)
            ? extra!['productId'] as int
            : int.tryParse('${extra?['productId']}') ?? 0;
        final List<Map<String, dynamic>> listProductsPromotions =
            (extra != null && extra['relatedProducts'] is List)
            ? List<Map<String, dynamic>>.from(extra['relatedProducts'] as List)
            : <Map<String, dynamic>>[];

        final ProductItem productItem = extra?['productItem'];

        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 800),

          child: ProductDetail(
            productCode: productCode,
            relateProducts: listProductsPromotions,
            productItem: productItem,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: Curves.easeInOut));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: PathRoutes.payments,
      name: 'payments',
      pageBuilder: (context, state) {
        final Map<String, String>? extra = state.extra as Map<String, String>?;

        final String total = extra?['total'] ?? '0';
        final String shipping = extra?['shipping'] ?? '0';
        final String subtotal = extra?['subtotal'] ?? '0';

        return CustomTransitionPage(
          key: state.pageKey,
          child: Payments(total: total, shipping: shipping, subtotal: subtotal),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: Curves.easeOutCubic));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
