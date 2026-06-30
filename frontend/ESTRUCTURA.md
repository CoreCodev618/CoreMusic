# Estructura del frontend — CoreTune

```
frontend/
├── .gitignore
├── pubspec.yaml
├── README.md
├── ESTRUCTURA.md
│
└── lib/
    ├── main.dart                          # Entry point, rutas, splash gate
    │
    ├── core/                              # Herramientas globales
    │   ├── theme/
    │   │   ├── app_colors.dart            # Paleta verde-teal / coral / ámbar
    │   │   ├── app_typography.dart        # Fraunces (títulos) + DM Sans (UI)
    │   │   └── app_theme.dart             # ThemeData Material 3
    │   ├── utils/
    │   │   └── constants.dart             # Constantes y formateador de tiempo
    │   └── services/                      # (vacío) audio_service se configura aquí
    │
    ├── domain/                            # Lógica independiente de UI
    │   ├── models/
    │   │   ├── song.dart
    │   │   ├── playlist.dart
    │   │   ├── lyric.dart
    │   │   └── taste_profile.dart         # Perfil de gustos (onboarding + IA)
    │   └── repositories/
    │       ├── song_repository.dart       # Contrato: búsqueda, historial, descargas
    │       └── recommendation_engine.dart # Contrato: motor de IA on-device
    │
    ├── data/                              # Fuentes de datos
    │   ├── local_db/                      # (vacío) esquemas Isar van aquí
    │   ├── network/
    │   │   └── mock_music_data.dart       # Datos falsos para construir el front
    │   └── repositories_impl/             # (vacío) implementación real de los contratos
    │
    └── presentation/                      # UI y estado
        ├── providers/
        │   ├── home_providers.dart        # Mixes, más escuchados, explorar, historial
        │   ├── player_providers.dart      # Estado de reproducción (placeholder)
        │   └── taste_profile_providers.dart # Selección de géneros/artistas
        ├── screens/
        │   ├── loading_screen.dart        # Splash con logo animado
        │   ├── onboarding_taste_screen.dart
        │   ├── main_shell.dart            # Bottom nav + mini-player
        │   ├── home_screen.dart
        │   ├── search_screen.dart
        │   ├── library_screen.dart
        │   ├── player_screen.dart         # Pantalla completa del reproductor
        │   └── profile_screen.dart
        └── widgets/
            ├── coretune_loading_logo.dart # Logo animado (aro + barras de audio)
            ├── music_card.dart            # Tarjeta usada en todas las secciones del Home
            ├── section_row.dart           # Fila scrollable con título de sección
            ├── genre_taste_card.dart      # Tarjetas/avatares del onboarding
            ├── mini_player.dart           # Reproductor persistente pegado al nav
            └── song_tile.dart             # Fila de canción (Search, Library)
```

## Flujo de navegación

```
/splash  →  /onboarding (saltable)  →  /home (MainShell: Home, Buscar, Biblioteca, Perfil)
                                            │
                                            └── /player (pantalla completa)
```

## Qué falta para producción (no incluido en este entregable de frontend)

- `data/network/`: servicio real con `youtube_explode_dart` (búsqueda + stream) y
  cliente `dio` para LRCLIB.
- `data/local_db/`: colecciones Isar para `Song`, `Playlist`, historial y
  perfil de gustos persistente.
- `data/repositories_impl/`: implementaciones concretas de
  `SongRepository` y `RecommendationEngine` (cálculo de embeddings +
  similitud coseno sobre el historial real).
- `core/services/`: configuración de `audio_service` para controles en
  pantalla de bloqueo y reproducción en segundo plano.
- Descargas reales con `dio` + `path_provider` en vez del flag mock
  `isDownloaded`.
