import 'package:audio_service/audio_service.dart';
import 'package:coretune/data/local_db/taste_profile_schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/audio_handler.dart';
import 'core/theme/app_theme.dart';
import 'data/local_db/isar_service.dart';
import 'presentation/providers/player_providers.dart';
import 'presentation/screens/loading_screen.dart';
import 'presentation/screens/onboarding_taste_screen.dart';
import 'presentation/screens/main_shell.dart';
import 'presentation/screens/player_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Abrir Isar (base de datos local)
  await IsarService.init();

  // 2. Registrar el handler de audio para segundo plano y lockscreen
  final audioHandler = await AudioService.init(
    builder: () => CoreTuneAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.coretune.channel',
      androidNotificationChannelName: 'CoreTune',
      androidNotificationOngoing: true,  // notificación no se puede swipear
      androidShowNotificationBadge: true,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        // Inyectar el handler real en el provider de Riverpod
        audioHandlerProvider.overrideWithValue(audioHandler),
      ],
      child: const CoreTuneApp(),
    ),
  );
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
        '/splash':      (_) => const _SplashGate(),
        '/onboarding':  (_) => const OnboardingTasteScreen(),
        '/home':        (_) => const MainShell(),
        '/player':      (_) => const PlayerScreen(),
      },
    );
  }
}

// Splash que decide si mostrar onboarding o ir directo al Home
class _SplashGate extends StatefulWidget {
  const _SplashGate();

  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    // Leer de Isar si el onboarding ya fue completado
    final profile = await IsarService.instance.tasteProfileSchemas.get(1);
    final completed = profile?.onboardingCompleted ?? false;
    final skipped = profile?.onboardingSkipped ?? false;

    final route = (completed || skipped) ? '/home' : '/onboarding';
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) => const LoadingScreen();
}
