import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavBarIndexNotifier extends StateNotifier<int> {
  NavBarIndexNotifier() : super(0);

  void setValue(int newValue) => state = newValue;
  void reset() => state = 0;
}

final navBarIndexNotifierProvider =
    StateNotifierProvider<NavBarIndexNotifier, int>(
      (ref) => NavBarIndexNotifier(),
    );
