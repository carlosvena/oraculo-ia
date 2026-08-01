abstract final class AppMetadata {
  static const version = '3.6.1';
  static const buildNumber = '46';
  static const buildDate = String.fromEnvironment(
    'BUILD_DATE',
    defaultValue: 'desarrollo local',
  );
  static const releaseNotes = <String>[
    'Arreglado: la pantalla de "Hoy" y el Manual Maestro mostraban un número de versión viejo fijo ("1.8" y "2.6") en vez del real. Ya muestran la versión actual siempre.',
    'Los desafíos de las misiones ahora piden escribir de verdad tu respuesta (mínimo 15 caracteres), no solo tocar "Sí, la completé" sin esfuerzo.',
    '2 misiones nuevas: IA multimodal (025) y Seguridad práctica (026). Van 26 misiones.',
    'Colores con más variedad: violeta, coral y verde azulado en vez de un solo tono. Menos monótono.',
    'De paso, los desafíos de las misiones núcleo ya no dicen "supervisor bancario" fijo — se adaptan a tu trabajo real.',
    'Misión 020 nueva: Costos y límites reales de la IA. Van 20 misiones.',
    'Se revirtieron el ícono nuevo y el widget de pantalla de inicio (rompían la apertura de la app). Volvemos a probarlos más adelante, de a uno.',
    'Arreglo urgente: la app rompía al abrir por un error mío en el botón atrás de la 3.0.3. Ya está solucionado.',
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
