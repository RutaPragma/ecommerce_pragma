import 'package:ecommerce_pragma/routes/routes.dart';
import 'package:go_router/go_router.dart';

class AppNavigator {
  static final AppNavigator _instance = AppNavigator._internal();
  factory AppNavigator() => _instance;
  AppNavigator._internal();

  void go(String path) => appRouter.go(path);
  void push(String path) => appRouter.push(path);
  void pop() {
    try {
      appRouter.pop();
    } on GoError {
      // If there is nothing to pop (e.g., appRouter stack is empty),
      // fallback to the dashboard route instead of throwing.
      appRouter.go(PathRoutes.dashboard);
    }
  }
}
