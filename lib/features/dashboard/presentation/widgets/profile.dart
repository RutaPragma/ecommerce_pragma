import 'package:ecommerce_pragma/commons/state/nav_bar_index_provider.dart';
import 'package:ecommerce_pragma/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

class Profile extends ConsumerWidget {
  Profile({super.key, required this.config});

  final AuthPresenter presenter = AuthPresenter();
  final Map<String, dynamic> config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      key: const Key('profile_future_builder'),
      future: presenter.getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            key: Key('profile_loading_center'),
            child: CircularProgressIndicator(
              key: Key('profile_loading_indicator'),
            ),
          );
        }

        final user = snapshot.data!;

        config['user']['name'] = user.name;
        config['user']['email'] = user.email;
        config['settings'][0]['icon'] = Icons.lock_outline;
        config['settings'][1]['icon'] = Icons.notifications_outlined;
        config['settings'][2]['icon'] = Icons.help_outline;
        config['settings'][0]['onTap'] = () {};
        config['settings'][1]['onTap'] = () {};
        config['settings'][2]['onTap'] = () {};
        config['onLogout'] = () {
          ref.read(navBarIndexNotifierProvider.notifier).setValue(0);
          presenter.logout();
        };

        return SafeArea(
          key: const Key('profile_safe_area'),
          child: DSProfileTemplate(
            key: const Key('profile_template'),
            config: config,
          ),
        );
      },
    );
  }
}
