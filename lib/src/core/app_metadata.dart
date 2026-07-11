abstract final class AppMetadata {
  static const version = '1.9.0-beta';
  static const buildNumber = '10';
  static const buildDate = String.fromEnvironment(
    'BUILD_DATE',
    defaultValue: 'desarrollo local',
  );
  static const releaseNotes = <String>[
    'Recuperación segura ante contenido inválido.',
    'Importación de respaldos con vista previa.',
    'Mejoras de accesibilidad y diagnóstico local.',
  ];
}
