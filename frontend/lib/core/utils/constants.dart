class AppConstants {
  AppConstants._();

  static const String appName = 'CoreTune';
  static const String lrcLibBaseUrl = 'https://lrclib.net/api/get';

  // Umbral de escuchas antes de volver a sugerir el cuestionario de gustos
  // si el usuario lo saltó en el onboarding.
  static const int listensBeforeTastePrompt = 5;
}

class TimeFormatter {
  TimeFormatter._();

  static String mmss(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
