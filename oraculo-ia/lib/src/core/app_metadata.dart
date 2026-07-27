abstract final class AppMetadata {
  static const version = '2.2.0-beta';
  static const buildNumber = '13';
  static const buildDate = String.fromEnvironment(
    'BUILD_DATE',
    defaultValue: 'desarrollo local',
  );
  static const releaseNotes = <String>[
    'Misiones profesionales 006 a 015.',
    'Comparador offline de modelos con fuentes.',
    'Mentor por voz y perfil local personalizado.',
  ];
}
