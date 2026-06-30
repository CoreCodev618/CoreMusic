import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/coretune_loading_logo.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CoreTuneColors.background,
      body: Center(
        child: CoreTuneLoadingLogo(size: 120),
      ),
    );
  }
}
