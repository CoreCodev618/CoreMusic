import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/network/mock_music_data.dart';
import '../widgets/song_tile.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final downloaded = MockMusicData.recentlyPlayed.where((s) => s.isDownloaded).toList();

    return Scaffold(
      backgroundColor: CoreTuneColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu biblioteca', style: CoreTuneTypography.screenTitle),
              const SizedBox(height: 4),
              Text('Canciones descargadas en tu dispositivo', style: CoreTuneTypography.cardSubtitle),
              const SizedBox(height: 18),
              Expanded(
                child: downloaded.isEmpty
                    ? Center(
                        child: Text('Aún no descargas canciones', style: CoreTuneTypography.cardSubtitle),
                      )
                    : ListView.separated(
                        itemCount: downloaded.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                        itemBuilder: (context, i) => SongTile(song: downloaded[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
