import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/network/mock_music_data.dart';
import '../widgets/song_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final results = MockMusicData.recentlyPlayed; // placeholder hasta conectar youtube_explode_dart

    return Scaffold(
      backgroundColor: CoreTuneColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buscar', style: CoreTuneTypography.screenTitle),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: CoreTuneColors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: CoreTuneColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: CoreTuneColors.textMuted, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: CoreTuneTypography.body,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          hintText: 'Canciones, artistas...',
                          hintStyle: CoreTuneTypography.cardSubtitle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, i) => SongTile(song: results[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
