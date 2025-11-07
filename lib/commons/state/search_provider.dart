import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends StateNotifier<String> {
  SearchNotifier() : super('');

  void updateQuery(String query) => state = query;
  void clear() => state = '';
}

final searchNotifierProvider = StateNotifierProvider<SearchNotifier, String>(
  (ref) => SearchNotifier(),
);
