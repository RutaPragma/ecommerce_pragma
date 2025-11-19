import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class BaseWidget {
  BaseWidget({
    required this.child,
    required this.overrides,
    this.shouldPumpAndSettle = true,
  });
  final Widget child;
  final List<Override> overrides;
  final bool shouldPumpAndSettle;

  Future<void> mount(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(home: child),
      ),
    );
    if (shouldPumpAndSettle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }
}
