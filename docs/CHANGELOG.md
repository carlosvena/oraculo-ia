# Changelog

Todos los cambios relevantes de ORÁCULO IA se registran aquí.

## Unreleased

- Próximo: Sprint 30 pendiente de definición.

## 2.9.0-sprint29 — 2026-07-14

- **CONTIENEDO ACADÉMICO MASIVO**: Expansión masiva offline de 8 cursos, 30 misiones completas con cuestionarios de 8 preguntas, 154 términos relacionados, 34 capítulos de manual y 15 proyectos prácticos de negocio.
- **Resumen del Universo**: Tarjeta de estadísticas consolidadas en la pantalla de bienvenida.
- **Novedades de la Versión**: Vista interactiva para navegar directamente al nuevo contenido.
- **Release Automatizado a OneDrive**: Copia automática de compilaciones y reportes a la carpeta Releases.
- **Control de Calidad Editorial**: Suite de pruebas epic9_content_test.dart y reporte audit docs/CONTENT_AUDIT_EPIC_9.md.

## 2.8.0-sprint28 — 2026-07-14

- **KNOWLEDGE UNIVERSE**: Nueva pantalla interactiva de navegación de la red de relaciones conceptuales y contenidos offline.
- **Relaciones Cruzadas**: Panel dinámico que detalla prerrequisitos, desbloqueos, laboratorios y proyectos relacionados de cualquier concepto.
- **Explorador Secuencial**: Navegador horizontal paso a paso para guiar la exploración jerárquica de temas (e.g. LLM -> Transformer -> Attention).
- **Concepto del Día**: Tarjeta premium con explicaciones analíticas, analogías e ilustraciones de conceptos destacados.
- **Desafío del Día**: Retos interactivos offline autogenerados de forma determinista para afinar habilidades sin IA externa.
- **Línea Temporal de Aprendizaje**: Registro cronológico interactivo de hitos de estudio reales.
- **Insignias de Maestría**: 5 condecoraciones que validan logros cognitivos y constancia sin centrarse en la gamificación por XP.
- **Panel Consolidado**: Métricas unificadas de horas de estudio, proyectos, laboratorios, repasos y metas semanales.

## 2.7.0-sprint27 — 2026-07-13

- **ORÁCULO AI LAB**: Nuevo espacio de experimentación interactiva offline.
- **50 Laboratorios**: Planificación detallada en 13 categorías distintas almacenada en `knowledge/ai_labs_v1.json`.
- **Editor y Comparador**: Interfaz de escritura de prompts que compara el original con la versión mejorada e incorpora aprendizajes.
- **Evaluador de Rúbricas Local**: Algoritmo offline que analiza la calidad del prompt (Claridad, Contexto, Restricciones, Formato y Objetivo) y provee oportunidades de mejora detalladas.
- **10 Plantillas Reutilizables**: Plantillas rápidas de negocio listas para copiar y personalizar.
- **Exportación Offline**: Soporte para copiar reportes de práctica estructurados en Markdown y simular descargas en formato PDF.

## 2.6.0-sprint26 — 2026-07-13

- **Catálogo de Cursos**: Nueva pantalla "Academia IA" con los 10 cursos principales por categorías.
- **Estructura de 100 Misiones**: Planificación de metadatos de 100 lecciones integradas offline.
- **Explorador Jerárquico**: Herramienta de navegación dinámica de Curso -> Misión -> Concepto -> Lab -> Proyecto.
- **Buscador Unificado**: Motor de búsqueda offline multientidad que indexa cursos, misiones, manual, diccionario, laboratorios y proyectos simultáneamente.
- **Portada de Bienvenida Espectacular**: Nueva página principal con metas de estudio, horas estudiadas reales, concepto del día y atajos para continuar el aprendizaje.
- **Mejoras Visuales Material 3**: Tarjetas modernas, iconos consistentes y banners premium.

## 2.5.0-sprint25 — 2026-07-13

- **ORÁCULO Learning Engine v2**: Motor de aprendizaje no lineal con grafo completo multi-entidad (misiones, conceptos, laboratorios, proyectos, glosario, manual).
- **Dominio Conceptual (Niveles 0-5)**: Seguimiento granular del nivel cognitivo de los conceptos (Leído, Comprendido, Dominado, etc.).
- **Detención Inteligente por Fallas**: Bloquea el avance y sugiere repasos o laboratorios cuando hay 3 o más errores consecutivos.
- **Proyectos de Track Bloqueantes**: Requiere la culminación del proyecto integrador para avanzar a tracks curriculares de automatización y agentes.
- **Ruta Dinámica Personalizada**: Algoritmo que calcula la mejor ruta del día según tiempo y metas.
- **Transferencia Cognitiva**: Adapta el tono didáctico del concepto si el usuario ya lo comprende.
- **Árbol de Conocimiento Interactivo**: Rediseño completo de la interfaz del mapa de conocimiento con visualización del árbol de dependencias, niveles y metas de estudio reales.

## 2.4.0-sprint24 — 2026-07-13

- **ORÁCULO Mentor Engine**: Arquitectura del tutor inteligente offline y adaptativo para guiar el aprendizaje.
- **Perfil Pedagógico**: Almacenamiento local de horas estudiadas, velocidad, conceptos dominados y errores frecuentes.
- **Recomendador Inteligente**: Propone siguientes pasos con justificación pedagógica en español.
- **Estilos Explicativos Alternativos**: Explicaciones offline en 7 tonos distintos (Formal, Simple, Analogía, etc.).
- **Dificultad Adaptativa**: Modificación dinámica del nivel de dificultad según rendimiento en quizzes.
- **Memoria de Interacciones**: Registro de conceptos explicados y analogías utilizadas para no repetirlas.
- **Planificador de Sesiones**: Diseña planes estructurados ajustados a disponibilidad de tiempo (e.g. 15 minutos o 1 hora) y objetivos.
- **Adaptadores LLM Desacoplados**: Interfaces y adaptadores listos para integrar APIs comerciales (OpenAI, Gemini, Claude, DeepSeek, etc.).
- **Panel del Mentor**: Dashboard interactivo que muestra métricas del tutor, fortalezas, debilidades y planes dinámicos.

## 2.3.0-sprint23 — 2026-07-13

- **ORÁCULO Creator Studio**: CMS offline interno para mantenimiento y validación visual de la base de conocimiento en `knowledge/`.
- **Dashboard Central**: Muestra estadísticas en tiempo real y el estado de la integridad semántica.
- **Editores Visuales Dedicados**: Permiten agregar, modificar, borrar y reordenar elementos para cursos, lecciones (bloques didácticos y cuestionarios), glosario, manual, biblioteca de pensamiento, laboratorios de prompts y proyectos finales.
- **Validador Semántico Integrado**: Detección de conceptos huérfanos, enlaces rotos, preguntas sin respuesta, y capítulos vacíos.
- **Persistencia en Disco**: Utilidad de exportación directa que guarda los archivos JSON estructurados de forma offline en la carpeta del proyecto.

## 2.2.0-sprint22 — 2026-07-13

- **Consolidación del Motor de Conocimiento**: centralización total de contenidos curriculares.
- Extensión de `KnowledgeEngine` para cargar todos los JSONs restantes: caminos profesionales (`career_paths_v1.json`), proyectos (`projects_v1.json`), ejercicios de prompt (`prompt_exercises_v1.json`), ideas (`thought_library_v1.json`/`thought_library_expansion_v1.json`) y catálogo de modelos (`model_catalog_v1.json`).
- Separación física de los modelos de datos `CareerPath` y `LearningProject` a archivos de dominio propios, desacoplándolos de la presentación.
- Refactorización de todas las pantallas y lectores para utilizar los datos validados y en caché del motor, eliminando redundancias de acceso a disco nativo.
- Validación de integridad semántica cruzada en el arranque: comprobación de referencias de misiones contra metadatos cargados y taxonomías curriculares.

## 2.1.0-sprint21 — 2026-07-13

- **Motor de Conocimiento (Knowledge Engine)**: reestructuración modular offline de contenidos.
- Fraccionamiento de los JSON monolíticos en archivos independientes: misiones individuales (`knowledge/missions/lesson-*.json`), diccionario (`dictionary_v1.json`), manual (`manual_v1.json`) y taxonomías curriculares (`modules_v1.json`).
- Centralización y validación automática de datos en `KnowledgeEngine` al arrancar la aplicación.
- Implementación de lazy loading en repositorios de lecciones para posibilitar miles de misiones sin penalización de memoria.
- Detección estricta de errores editoriales: validación semántica de enlaces rotos y detección de ciclos cerrados en prerrequisitos de misiones (DFS).
- Integración de búsqueda indexada semántica rápida sobre manual y diccionario.

## 2.0.0-sprint20 — 2026-07-13

- **Operación Pulido (Operation Polish)**: unificación estética global y refactorización visual.
- Integración de temas de componentes Material 3 en `app_theme.dart` (tarjetas, listiles, inputs, chips, sliders y segmented buttons).
- Rediseño de la sección de exploración en `CurrentMissionScreen` como un Grid unificado y premium.
- Refactorización, formateo y saneamiento de 6 archivos de presentación minificados.
- Adopción de `AppSpacing` en todas las vistas de la aplicación.
- Notificaciones emergentes Snackbars para feedback visual interactivo.
- Resolución de lints y deprecaciones de entrada.
- Creación de la guía de estilos `docs/UI_GUIDELINES.md` y auditoría visual `docs/UI_AUDIT.md`.

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
# 1.9.0-beta — Sprint 10

- Añadida recuperación segura ante errores de navegación o contenido.
- Añadida vista previa antes de importar un respaldo.
- Añadido diagnóstico local exportable.
- Mejorados texto grande, pantallas pequeñas, contraste semántico y legibilidad.
- Añadidos metadatos y notas de versión visibles.
- Añadidos script reproducible de release e instrucciones de instalación.
# 2.0.0-beta — Sprint 11

- Incorporadas las Misiones 006 a 015 con contenido profesional offline.
- Incorporados laboratorios, casos reales, actividades de palabras propias y desafíos de construcción.
- Añadidas 80 preguntas con explicación editorial.
- Añadido lector y validador para el catálogo avanzado versionado.
- Corregido el tiempo estimado de cada misión en la interfaz.
# 2.1.0-beta — Sprint 12

- Añadido comparador offline de ChatGPT, Gemini, Claude, Copilot, DeepSeek, Qwen, GLM, Grok, Mistral y Llama.
- Añadidos filtros para nueve tipos de tarea.
- Añadidos fuente, fecha editorial y estado de verificación por ficha.
- Añadidas advertencias de privacidad y campos de costo editables.
# 2.2.0-beta — Sprint 13

- Añadida lectura en voz alta con velocidad, pausa y manos libres básico.
- Añadidas tres reformulaciones editoriales locales por bloque.
- Añadido perfil privado y offline de Carlos.
- Ampliada la biblioteca de pensamiento a diez referentes.
- Añadidos metadatos de fuente y verificación visibles.
# 2.3.0-beta - Sprint 14

- Añadido módulo de evaluación abierta con seis tipos de actividad.
- Añadida rúbrica profesional local de seis criterios.
- Añadidas pruebas de dominio cada cinco misiones.
- Añadida revisión personal de respuestas y ejemplos sólidos.
# 2.4.0-beta - Sprint 15

- Añadido motor local de repaso espaciado y priorizado.
- Añadidas sesiones de tres duraciones con cuatro tipos de actividad.
- Añadido registro persistente de errores y seguridad declarada.
- Añadida explicación de recomendación y próxima fecha.
# 2.5.0-beta - Sprint 16

- Añadido manifiesto de gobierno editorial.
- Añadidas validaciones de fuentes, citas, fechas y caducidad.
- Añadida pantalla Estado del conocimiento.
# 2.6.0-beta - Sprint 17

- Añadido Manual Maestro exportable en PDF, Markdown y HTML.
- Añadidos filtros de exportación y modo lectura accesible.
- Añadido PDF real de validación en releases.
# 2.7.0-beta - Sprint 18

- Añadido Constructor de proyectos con cinco recorridos completos.
- Añadidos checklist, progreso, evaluación y documentación requerida.
# 2.8.0-beta - Sprint 19

- Añadidos ocho caminos profesionales personalizados.
- Añadidos progreso, pendientes y evaluación final por camino.
