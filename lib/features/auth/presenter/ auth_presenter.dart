// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:ecommerce_pragma/core/helper/app_navigator.dart';
import 'package:ecommerce_pragma/features/auth/auth.dart';
import 'package:ecommerce_pragma/routes/app_router.dart';
import 'package:ecommerce_pragma/routes/path_routes.dart';
import 'package:flutter/material.dart';

class AuthPresenter {
  final MockAuthService _authService = MockAuthService();

  AuthPresenter();

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        log('Login exitoso: ${user.email}');
        appRouter.go(PathRoutes.dashboard);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña inválidos')),
      );

      // aquí puedes mostrar un snackbar o similar
    }
  }

  void googleLogin() {
    log('Auth Google');
    // simulación de login con Google
  }

  void appleLogin() {
    log('Auth Apple');
    // simulación de login con Apple
  }

  Future<void> register(BuildContext context, Map<String, dynamic> data) async {
    try {
      final user = await _authService.register(
        data['email'],
        data['name'],
        data['password'],
      );
      log('Usuario registrado: ${user.email}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuario registrado')));
      await Future.delayed(const Duration(seconds: 1));
      AppNavigator().go(PathRoutes.dashboard);
    } catch (e) {
      final String message = e.toString();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      log('Error registro: $e');
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    appRouter.go(PathRoutes.auth);
  }

  Future<UserModel?> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }
}
