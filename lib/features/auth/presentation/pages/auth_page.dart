import 'package:ecommerce_pragma/core/localization/app_localizations.dart';
import 'package:ecommerce_pragma/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  late final AuthPresenter presenter;

  late Map<String, dynamic> _buttonHandlers;

  Map<String, DSIcon> get _iconHandlers => {
    'google': const DSIcon(
      icon: Icons.g_mobiledata,
      color: DSIconColor.onPrimary,
      size: DSSize.large,
    ),
    'apple': const DSIcon(icon: Icons.apple),
  };

  @override
  void initState() {
    super.initState();
    presenter = AuthPresenter();

    _buttonHandlers = {
      'googleLogin': presenter.googleLogin,
      'AppleLogin': presenter.appleLogin,
    };
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);
    final Map<String, dynamic> authConfig =
        language.localizedStrings['auth_page'];

    final List<DSButton> socialButtons = authConfig.containsKey('socialButtons')
        ? authConfig['socialButtons']
              .asMap()
              .map<int, DSButton>(
                (i, btn) => MapEntry(
                  i,
                  DSButton(
                    key: Key('auth_social_button_${btn['icon'] ?? i}'),
                    label: btn['label'],
                    onPressed: _buttonHandlers[btn['onPressed']] ?? () {},
                    variant: DSButtonVariant.disabled,
                    backgroundColor: btn['backgroundColor'],
                    textColor: btn['textColor'],
                    icon: _iconHandlers[btn['icon']],
                    isFullWidth: false,
                  ),
                ),
              )
              .values
              .toList()
        : [];

    return Material(
      key: const Key('auth_material'),
      child: DSAuthTemplate(
        key: const Key('auth_template'),
        config: authConfig,
        socialButtons: socialButtons,
        onLogin: (email, password) => presenter.login(context, email, password),
        onRegister: (data) => presenter.register(context, data),
      ),
    );
  }
}
