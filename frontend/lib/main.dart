import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/loading_screen.dart';
import 'presentation/screens/onboarding_taste_screen.dart';
import 'presentation/screens/main_shell.dart';
import 'presentation/screens/player_screen.dart';
void main() {
  runApp(const ProviderScope(child: CoreTuneApp()));
}

class CoreTuneApp extends StatelessWidget {
  const CoreTuneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoreTune',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const _SplashGate(),
        '/onboarding': (_) => const OnboardingTasteScreen(),
        '/home': (_) => const MainShell(),
        '/player': (_) => const PlayerScreen(),
      },
    );
  }
}

/// Splash temporal: simula la carga inicial (Isar, permisos, etc.) y
/// decide si mostrar onboarding o ir directo al Home.
class _SplashGate extends StatefulWidget {
  const _SplashGate();

  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      // TODO: leer de Isar si el onboarding ya fue completado/saltado antes.
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) => const LoadingScreen();
}
