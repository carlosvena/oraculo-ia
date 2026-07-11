# Changelog

Todos los cambios relevantes de ORÁCULO IA se registran aquí.

## Unreleased

- Próximo: Sprint 10 pendiente de definición.

## 1.8.0-beta — 2026-07-11

- Home diaria con plan, meta semanal, repaso y recomendación local.
- Continuidad persistente y navegación consolidada a todos los módulos.
- Acerca del proyecto, versión visible y respaldo JSON exportable/importable.
- Icono profesional provisional y splash nativo oscuro.
- APK ARM64: `releases/Aprender IA 1.8 Beta.apk`.

## 1.7.0-sprint8 — 2026-07-11

- Mapa de conocimiento navegable con cinco estados visuales.
- Relaciones entre conceptos y misiones con apertura contextual.
- Implementación liviana orientada a rendimiento Android.

## 1.6.0-sprint7 — 2026-07-11

- Laboratorio offline con editor, historial, favoritos y comparación explicada.
- Veinte ejercicios reales organizados en siete categorías y tres niveles.
- Motor local de evaluación editorial y pruebas asociadas.

## 1.5.0-sprint6 — 2026-07-11

- Biblioteca de pensamiento offline con búsqueda, filtros y favoritos.
- Ocho ideas editoriales iniciales de seis referentes, claramente tipificadas.
- Validación y pruebas del nuevo contenido desacoplado.

## 1.4.0-sprint5 — 2026-07-11

### Added

- Persistencia local completa del recorrido de aprendizaje.
- Restauración exacta de bloque y respuestas.
- Modos esencial e intensivo persistentes.
- Misiones 003, 004 y 005 con contenido profesional y evaluaciones exigentes.
- Progreso real, autoevaluación y sección visible de repaso.
- Favoritos para manual y diccionario.
- Diez términos nuevos y tres artículos del manual.
- Pruebas de restauración, modo, repaso, desbloqueo y búsqueda.

### Changed

- El catálogo muestra cinco misiones con desbloqueo secuencial.
- XP deja de ser el indicador principal de progreso.

### Verified

- Análisis estático sin errores y 13 pruebas aprobadas.
- APK x86_64 ejecutada y persistencia validada tras relanzar la aplicación.

### Artifact

- `releases/Aprender IA 1.4.apk` (ARM64).
- `releases/Aprender IA 1.4 Emulator x64.apk`.

## 1.3.0-sprint4 — 2026-07-11

### Added

- Contenido educativo JSON versionado y validado desde `knowledge/`.
- Misión 002 profesional con doce bloques, laboratorio y ocho preguntas.
- Manual offline navegable con búsqueda local y diccionario enlazado.
- Catálogo de misiones con desbloqueo de Misión 002.
- Pruebas de carga, errores editoriales, búsqueda, enlaces y desbloqueo.

### Changed

- Misión 001 se carga desde contenido separado del código.
- Accesos secundarios a Manual, Diccionario y Catálogo.

### Verified

- Análisis estático sin errores y 10 pruebas aprobadas.
- APK x86_64 ejecutada en emulador Android.

### Artifact

- `releases/Aprender IA 1.3.apk` (ARM64).
- `releases/Aprender IA 1.3 Emulator x64.apk`.

## 1.2.0-sprint3 — 2026-07-11

### Added

- Experiencia educativa de nueve bloques para la Misión 001.
- Componente visual reutilizable `LessonBlock`.
- Analogía, ejemplo práctico y mini laboratorio.
- Quiz obligatorio de cinco preguntas con explicaciones específicas.
- Progreso por bloque, porcentaje y tiempo simulado dentro de la misión.
- Conceptos aprendidos y Misión 002 desbloqueada en el cierre.

### Changed

- Jerarquía visual, espaciado y tarjetas de la misión mejorados.
- Métricas de tiempo adaptadas a pantallas angostas.

### Verified

- Análisis estático sin errores.
- 6 pruebas automatizadas aprobadas.
- APK recorrida de principio a fin en emulador Android.

### Artifact

- `releases/Aprender IA 1.2.apk`
- Capturas reales: `screenshots/sprint3-*.png`

## 1.1.0-sprint2 — 2026-07-10

### Added

- Estados No iniciada, En progreso y Completada para Misión 001.
- Progreso visual por misión.
- Tiempo estimado y tiempo empleado simulado.
- Ejercicio interactivo y cuestionario obligatorio de tres preguntas.
- Nivel 1 y racha simulada de un día en la pantalla final.

### Verified

- Análisis estático sin errores.
- 6 pruebas automatizadas aprobadas.
- Recorrido completo validado en un emulador Android.

### Artifact

- `releases/Aprender IA 1.1.apk`
- Capturas reales: `screenshots/sprint2-*.png`

## 0.1.0-sprint1 — 2026-07-10

### Added

- Primera experiencia móvil completa y simulada.
- Splash, Bienvenida, Mi misión, Misión 001 y Progreso.
- Misión 001 con contenido pedagógico y mini evaluación interactiva.
- Progreso simulado con 100 XP, barra y Misión 002 bloqueada.
- Tema oscuro Material 3 e interfaz en español.
- Runner Android y APK release instalable.

### Fixed

- Bienvenida ya no navega automáticamente durante la inicialización del ViewModel.
- Constructores inmutables de Academy y Learning Engine corregidos.
- Generación y ubicación de archivos de internacionalización corregidas.
- Consumo de memoria de Gradle limitado para permitir builds en el equipo actual.

### Verified

- Análisis estático sin errores.
- Cinco pruebas automatizadas aprobadas.
- Instalación y recorrido completo en emulador Android 35.

### Artifact

- `releases/Aprender IA 1.apk`
