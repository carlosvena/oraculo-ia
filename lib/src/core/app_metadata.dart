abstract final class AppMetadata {
  static const version = '2.12.0';
  static const buildNumber = '23';
  static const buildDate = String.fromEnvironment(
    'BUILD_DATE',
    defaultValue: 'desarrollo local',
  );
  static const releaseNotes = <String>[
    'Espacio de trabajo personal (Mi Workspace) offline.',
    'Notebook Markdown con autoguardado y formato rápido.',
    'Prompt Vault para catalogar y versionar prompts.',
    'Registro de Experimentos con objetivos e hipótesis.',
    'Buscador global integrado con notas y prompts del Workspace.',
    'Exportación del Workspace y backups con integridad SHA256.',
  ];
}
