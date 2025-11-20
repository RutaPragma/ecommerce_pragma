// test/commons/state/main_state.dart
import 'car_items_provider_test.dart' as car_items;
import 'loading_provider_test.dart' as loading;
import 'nav_bar_index_provider_test.dart' as nav_bar_index;
import 'search_provider_test.dart' as search;
import 'theme_provider_test.dart' as theme;
import 'localization_provider_test.dart' as localization;

void main() {
  car_items.main();
  loading.main();
  nav_bar_index.main();
  search.main();
  theme.main();
  localization.main();
}
