import 'package:flutter/material.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

class AnimatedSplash extends StatefulWidget {
  const AnimatedSplash({super.key});

  @override
  State<AnimatedSplash> createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: const Key('animated_splash_scaffold'),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _controller,
              child: Image.asset(
                'assets/img/logo.png',
                width: 120,
                key: const Key('splash_logo_img'),
              ),
            ),
            FadeTransition(
              opacity: _controller,
              child: Text(
                'Ecommerce',
                key: const Key('splash_logo_text'),
                style: DSTypography.displayXLBold.copyWith(
                  color: isDark
                      ? DSColorsFoundations.brandSecondaryDark
                      : DSColorsFoundations.brandSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
