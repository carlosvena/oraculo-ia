abstract final class AppMetadata {
  static const version = '3.0.3';
  static const buildNumber = '23';
  static const buildDate = String.fromEnvironment(
    'BUILD_DATE',
    defaultValue: 'desarrollo local',
  );
  static const releaseNotes = <String>[
    'Botón atrás de Android arreglado en toda la app: te lleva a Hoy antes de salir.',
    'Barra de accesos rápidos de vuelta (Hoy / Mi curso / Practicar / Explorar / Mi progreso).',
    'Firma de compilación estable: las actualizaciones ya no borran el progreso.',
    'Quiz de las lecciones rediseñado: opciones grandes, con letras y colores bien visibles.',
    'Misión 016 nueva: aplicá todo lo aprendido a tu propio trabajo (se adapta a cualquier profesión, no solo bancario).',
    'Perfil de usuario real y editable (antes venía fijo en el código).',
    'Reiniciar progreso desde la app, con confirmación.',
    'El botón atrás de Android ya no cierra la app de golpe.',
    'Compilación automática de APK en cada actualización.',
  ];
}
