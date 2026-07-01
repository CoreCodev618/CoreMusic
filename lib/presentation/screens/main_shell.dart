import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/mini_player.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreTuneColors.background,
      body: _screens[_index],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(), // pegado justo encima de la barra, sin separación
          BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            backgroundColor: CoreTuneColors.backgroundDeep,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
              BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: 'Biblioteca'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
            ],
          ),
        ],
      ),
    );
  }
}
