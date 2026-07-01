import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/song.dart';
import '../../presentation/providers/player_providers.dart';
import '../../presentation/widgets/song_tile.dart';

// Provider de búsqueda — AsyncNotifier para manejar loading/error/data
class SearchController extends AsyncNotifier<List<Song>> {
  @override
  Future<List<Song>> build() async => [];

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();

    final repo = ref.read(songRepositoryProvider);
    state = await AsyncValue.guard(() => repo.search(query));
  }

  void clear() => state = const AsyncData([]);
}

final searchControllerProvider =
    AsyncNotifierProvider<SearchController, List<Song>>(SearchController.new);

// ─── PANTALLA ────────────────────────────────────────────────────────────────

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onSubmit(String query) {
    ref.read(searchControllerProvider.notifier).search(query);
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchControllerProvider);
    final playerState = ref.watch(playerControllerProvider);

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

              // ── Barra de búsqueda ──
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
                        focusNode: _focus,
                        style: CoreTuneTypography.body,
                        textInputAction: TextInputAction.search,
                        onSubmitted: _onSubmit,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          hintText: 'Canciones, artistas...',
                          hintStyle: CoreTuneTypography.cardSubtitle,
                        ),
                      ),
                    ),
                    // Botón limpiar
                    if (_controller.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _controller.clear();
                          ref.read(searchControllerProvider.notifier).clear();
                        },
                        child: const Icon(Icons.close,
                            color: CoreTuneColors.textMuted, size: 16),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Error del reproductor ──
              if (playerState.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    playerState.error!,
                    style: CoreTuneTypography.cardSubtitle
                        .copyWith(color: CoreTuneColors.coral),
                  ),
                ),

              // ── Resultados / Loading / Empty ──
              Expanded(
                child: searchState.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: CoreTuneColors.coral,
                      strokeWidth: 2,
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Text(
                      'Error al buscar. Revisa tu conexión.',
                      style: CoreTuneTypography.cardSubtitle,
                    ),
                  ),
                  data: (songs) {
                    if (songs.isEmpty) {
                      return Center(
                        child: Text(
                          'Busca una canción o artista',
                          style: CoreTuneTypography.cardSubtitle,
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: songs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (context, i) => SongTile(song: songs[i]),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
