import 'package:dio/dio.dart';

/// Consume la API pública gratuita de LRCLIB.
/// No requiere API key ni autenticación.
///
/// Documentación: https://lrclib.net/docs
class LrcLibClient {
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://lrclib.net/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  // ─── OBTENER LETRAS ───────────────────────────────────────────────────────

  /// Retorna las letras sincronizadas (formato LRC con timestamps) o
  /// null si LRCLIB no tiene la canción.
  ///
  /// Uso:
  ///   final lines = await lrclib.getLyrics(artist: 'Daft Punk', track: 'Get Lucky');
  ///   // lines = [ LyricLine(timestamp: 0:12.00, text: 'Like the legend of the phoenix') ]
  Future<List<LyricLine>?> getLyrics({
    required String artist,
    required String track,
    String? album,
  }) async {
    try {
      final response = await _dio.get(
        '/get',
        queryParameters: {
          'artist_name': artist,
          'track_name': track,
          if (album != null) 'album_name': album,
        },
      );

      if (response.statusCode != 200) return null;

      final syncedLyrics = response.data['syncedLyrics'] as String?;

      // Si no hay letras sincronizadas, intentar con las planas
      if (syncedLyrics == null || syncedLyrics.isEmpty) {
        final plainLyrics = response.data['plainLyrics'] as String?;
        if (plainLyrics == null || plainLyrics.isEmpty) return null;
        return _parsePlainLyrics(plainLyrics);
      }

      return _parseLrc(syncedLyrics);
    } on DioException {
      return null;
    }
  }

  // ─── PARSEO LRC ───────────────────────────────────────────────────────────

  /// Parsea el formato LRC a una lista de LyricLine con timestamps.
  ///
  /// Formato LRC:
  ///   [00:12.00] Like the legend of the phoenix
  ///   [00:17.20] Their fire once ignited
  List<LyricLine> _parseLrc(String lrc) {
    final lines = <LyricLine>[];

    // Regex para capturar [mm:ss.xx] o [mm:ss.xxx]
    final regex = RegExp(r'\[(\d{2}):(\d{2})\.(\d{2,3})\](.*)');

    for (final raw in lrc.split('\n')) {
      final match = regex.firstMatch(raw.trim());
      if (match == null) continue;

      final minutes = int.parse(match.group(1)!);
      final seconds = int.parse(match.group(2)!);
      // Normalizar a milisegundos (2 o 3 dígitos)
      final msStr = match.group(3)!.padRight(3, '0');
      final ms = int.parse(msStr);
      final text = match.group(4)!.trim();

      // Ignorar líneas vacías (silencios en el karaoke)
      if (text.isEmpty) continue;

      lines.add(LyricLine(
        timestamp: Duration(minutes: minutes, seconds: seconds, milliseconds: ms),
        text: text,
      ));
    }

    return lines;
  }

  /// Convierte letras planas (sin timestamps) en LyricLine con
  /// timestamp 0 — al menos se muestran aunque no hagan scroll automático.
  List<LyricLine> _parsePlainLyrics(String plain) {
    return plain
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .map((l) => LyricLine(timestamp: Duration.zero, text: l.trim()))
        .toList();
  }
}

// ─── MODELO ───────────────────────────────────────────────────────────────

/// Una línea de letra con su timestamp.
/// El timestamp se usa en LyricsView para el scroll automático tipo karaoke.
class LyricLine {
  final Duration timestamp;
  final String text;

  const LyricLine({required this.timestamp, required this.text});
}
