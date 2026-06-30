# CoreTune — Frontend (Flutter)

Cliente de streaming musical local-first, open-source. Este paquete contiene
el **frontend completo con datos mock**, listo para conectar la capa de datos
real (youtube_explode_dart, LRCLIB, Isar) descrita en el documento maestro del
proyecto.

## Estado actual

- ✅ Theme, colores y tipografía (Fraunces + DM Sans) aprobados.
- ✅ Splash / loading screen con logo animado.
- ✅ Onboarding de gustos (tarjetas seleccionables, saltable).
- ✅ HomeScreen con 4 secciones: Hecho para ti, Tus más escuchados, Explorar
  nuevo, Últimos escuchados.
- ✅ SearchScreen, LibraryScreen, ProfileScreen, PlayerScreen.
- ✅ Mini-reproductor persistente + Bottom Navigation Bar.
- ✅ Estado global con Riverpod (datos mock en `data/network/mock_music_data.dart`).
- ⏳ Pendiente: conectar `youtube_explode_dart`, `audio_service`, `just_audio`,
  Isar, y el motor de recomendación on-device (embeddings + similitud coseno).

## Cómo correrlo

```bash
flutter pub get
flutter run
```

> Nota: como aún no está conectada la base de datos Isar, no es necesario
> correr `build_runner` todavía. Cuando se agreguen los esquemas reales en
> `data/local_db/`, correr:
> ```bash
> dart run build_runner build -d
> ```

## Dónde reemplazar los datos mock

Todo lo que hoy es falso vive en:
- `lib/data/network/mock_music_data.dart`

Una vez conectada la red y la base de datos, los providers en
`lib/presentation/providers/` deben apuntar a implementaciones reales de:
- `domain/repositories/song_repository.dart`
- `domain/repositories/recommendation_engine.dart`

## Estructura

Ver `ESTRUCTURA.md` para el árbol completo de carpetas y qué va en cada una.
