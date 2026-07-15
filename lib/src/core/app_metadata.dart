abstract final class AppMetadata {
  static const version = '2.11.0';
  static const buildNumber = '22';
  static const buildDate = String.fromEnvironment(
    'BUILD_DATE',
    defaultValue: 'desarrollo local',
  );
  static const releaseNotes = <String>[
    'Modo Oficina con herramientas avanzadas.',
    '300 prompts corporativos listos para copiar.',
    '210 desafíos de inferencia por nivel de dificultad.',
    'Simulador interactivo con rúbrica local y puntuación.',
    'Panel interno de métricas y líneas de código.',
  ];
}
