abstract final class AppMetadata {
  static const version = '3.0.5';
  static const buildNumber = '25';
  static const buildDate = String.fromEnvironment(
    'BUILD_DATE',
    defaultValue: 'desarrollo local',
  );
  static const releaseNotes = <String>[
    'Misión 017 nueva: criterio ante contenido generado por IA (deepfakes, desinformación).',
    'Red de contención: si algo falla al abrir una pantalla, se ve un mensaje amigable en vez de que la app se cuelgue.',
    'Botones de favoritos ahora anunciables por lectores de pantalla.',
    'Opciones del quiz con descripción accesible (correcta/incorrecta) para lectores de pantalla.',
    'Más tests automáticos (perfil, reinicio de progreso, personalización de misiones).',
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
