# Changelog

Todos los cambios relevantes de ORÁCULO IA se registran aquí.

## Unreleased

- Sin cambios. Sprint 5 no iniciado.

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
