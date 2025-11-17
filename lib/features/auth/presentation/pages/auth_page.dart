import 'package:ecommerce_pragma/commons/state/state.dart';
import 'package:ecommerce_pragma/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

/// Página de autenticación que gestiona login y registro.
///
/// Utiliza inyección de dependencia mediante [localizationProvider]
/// para acceder a las traducciones, eliminando la dependencia directa
/// a [BuildContext] para localización.
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

/// Estado de [AuthPage].
class _AuthPageState extends ConsumerState<AuthPage> {
  /// Presentador de la lógica de autenticación.
  late final AuthPresenter presenter;

  /// Mapa de manejadores para botones de acción.
  late Map<String, dynamic> _buttonHandlers;

  /// Mapa de iconos para botones sociales.
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
    /// Obtiene [AppLocalizations] desde el provider inyectado.
    final language = ref.watch(localizationProvider);
    final Map<String, dynamic> authConfig =
        language.localizedStrings['auth_page'];

    final List<DSButton> socialButtons = authConfig.containsKey('socialButtons')
        ? authConfig['socialButtons']
              .map<DSButton>(
                (btn) => DSButton(
                  key: Key(
                    'auth_social_button_${btn['icon'] ?? btn['indexId']}',
                  ),
                  label: btn['label'],
                  onPressed: _buttonHandlers[btn['onPressed']] ?? () {},
                  variant: DSButtonVariant.disabled,
                  backgroundColor: btn['backgroundColor'],
                  textColor: btn['textColor'],
                  icon: _iconHandlers[btn['icon']],
                  isFullWidth: false,
                ),
              )
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
