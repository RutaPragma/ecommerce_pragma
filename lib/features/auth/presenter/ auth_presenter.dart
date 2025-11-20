// ignore_for_file: use_build_context_synchronously

import 'package:ecommerce_pragma/core/helper/app_navigator.dart';
import 'package:ecommerce_pragma/features/auth/auth.dart';
import 'package:ecommerce_pragma/routes/app_router.dart';
import 'package:ecommerce_pragma/routes/path_routes.dart';
import 'package:flutter/material.dart';

class AuthPresenter {
  AuthPresenter({required MockAuthService this.authService});

  final MockAuthService authService;

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final user = await authService.login(email, password);
      if (user != null) {
        appRouter.go(PathRoutes.dashboard);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña inválidos')),
      );
    }
  }

  void googleLogin() {}

  void appleLogin() {}

  Future<void> register(BuildContext context, Map<String, dynamic> data) async {
    try {
      final user = await authService.register(
        data['email'],
        data['name'],
        data['password'],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario registrado: ${user.name}')),
      );
      await Future.delayed(const Duration(seconds: 1));
      AppNavigator().go(PathRoutes.dashboard);
    } catch (e) {
      final String message = e.toString();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> logout() async {
    await authService.logout();
    appRouter.go(PathRoutes.auth);
  }

  Future<UserModel?> getCurrentUser() async {
    return await authService.getCurrentUser();
  }
}
