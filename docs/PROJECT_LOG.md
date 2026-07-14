# ORÁCULO IA — Project Log

## Sprint 0 — Fundación

### Terminado

- Proyecto Flutter con Material 3, modo oscuro, Riverpod y go_router.
- Arquitectura modular feature-first y contratos de dominio.
- Flujo estructural Splash, Bienvenida, Mi misión, Lección y Progreso.
- Internacionalización ARB y base editorial `knowledge/`.

### Pendiente al cierre

- Una experiencia funcional ejecutable.
- Toolchain Android y artefacto instalable.

## Sprint 0.5 — Consolidación

### Terminado

- Contratos puros de `learning_engine` sin implementaciones.
- Modelos curriculares puros de `academy`.
- Visión de producto y revisión de riesgos arquitectónicos.

### Pendiente al cierre

- Validar los contratos con casos pedagógicos reales antes de estabilizarlos.

## Sprint 1 — Primera experiencia usable

### Terminado

- Flujo completo: Splash → Bienvenida → Mi misión → Misión 001 → Progreso → Mi misión.
- Misión 001 de aproximadamente 15 minutos con objetivo, importancia, explicación,
  ejemplo, ejercicio, mini evaluación y resumen.
- Feedback inmediato en la mini evaluación.
- Progreso simulado: +100 XP, barra al 50 %, felicitación y Misión 002 bloqueada.
- Corrección del salto automático de Bienvenida detectado en ejecución real.
- Flutter 3.44.6 y Android toolchain configurados.
- `flutter analyze` sin problemas y 5 pruebas aprobadas.
- APK release universal compilado e instalado correctamente en Android 35.
- Capturas reales obtenidas desde el APK mediante un emulador Android.

### Entregables

- APK: `releases/Aprender IA 1.apk`
- Capturas: `screenshots/`
- Código fuente Flutter y runner Android.

### Pendiente para versión 0.1

- Persistencia del progreso.
- Identidad de aplicación, icono y Splash nativo definitivos.
- Firma release privada y proceso reproducible de distribución.
- Pruebas de widget del flujo completo y validación en un teléfono físico.

### Próximo paso

Revisión de producto de Sprint 1 con Carlos. Sprint 2 no iniciado.

## Sprint 2 — Experiencia totalmente navegable

### Terminado

- Estado simulado `No iniciada → En progreso → Completada`.
- Barra de progreso en Mi misión, durante la misión y al finalizar.
- Tiempo estimado de 15 minutos y tiempo empleado simulado de 12 minutos.
- Pantalla final con 100 XP, Nivel 1, racha de 1 día y próxima misión bloqueada.
- Ejercicio interactivo y autoevaluación de tres preguntas obligatorios.
- Siguiente acción explícita según el estado de la misión.

### Calidad

- `flutter analyze`: sin problemas.
- 6 pruebas automatizadas aprobadas.

### Entregables

- APK release instalable: `releases/Aprender IA 1.1.apk`.
- Capturas reales del recorrido completo: `screenshots/sprint2-*.png`.
- Validación manual en emulador Android: bienvenida, misión, laboratorio,
  autoevaluación y progreso final.

### Pendiente al cierre

- Persistencia real: el estado se reinicia al cerrar el proceso.
- Revisión de producto y contenido con Carlos.

### Estado

Sprint 2 cerrado. Sprint 3 no iniciado; el proyecto queda detenido hasta recibir
nuevas instrucciones.

## Sprint 3 — Experiencia educativa v1

### Terminado

- Misión 001 reorganizada en nueve bloques navegables: título, objetivo,
  explicación, analogía, ejemplo, laboratorio, quiz, resumen y cierre.
- Renderizador reutilizable `LessonBlock` con identidad visual por tipo de bloque.
- Mini laboratorio obligatorio con explicación pedagógica.
- Quiz de cinco preguntas; cada respuesta muestra una explicación específica y
  el avance requiere cinco respuestas correctas.
- Progreso visible por bloque y porcentaje, con tiempo estimado y transcurrido
  simulado.
- Cierre con 100 XP, 12 minutos empleados, conceptos aprendidos y Misión 002
  desbloqueada.
- Jerarquía, aire, tarjetas y adaptación a pantallas angostas mejorados con
  Material 3.

### Calidad

- `flutter analyze`: sin problemas.
- 6 pruebas automatizadas aprobadas.
- Recorrido completo validado con la APK release en emulador Android.

### Entregables

- APK: `releases/Aprender IA 1.2.apk`.
- Capturas reales: `screenshots/sprint3-*.png`.
- Commit y publicación en GitHub.

### Estado

Sprint 3 cerrado. Sprint 4 no iniciado; el proyecto queda detenido para revisión.

## Sprint 4 — Plataforma educativa offline

### Terminado

- Contenido de las Misiones 001 y 002 separado del código en JSON versionado
  dentro de `knowledge/`, con validación y errores editoriales explícitos.
- Misión 002 «Anatomía de un prompt profesional»: 40 minutos, doce bloques,
  laboratorio, ocho preguntas y desafío aplicado a supervisión bancaria.
- Manual offline con índice, artículos, búsqueda y enlaces internos.
- Diccionario con LLM, Prompt, Token, Ventana de contexto y Agente de IA.
- Catálogo con duración, dificultad, estado, conceptos y desbloqueo de Misión 002.
- Accesos secundarios sin desplazar «CONTINUAR MI MISIÓN».

### Calidad y entregables

- `flutter analyze`: sin problemas; 10 pruebas aprobadas.
- APK ARM64: `releases/Aprender IA 1.3.apk`.
- APK de validación x86_64: `releases/Aprender IA 1.3 Emulator x64.apk`.
- Capturas reales: `screenshots/sprint4-*.png`.

### Estado

Sprint 4 cerrado. Sprint 5 no iniciado.

## Sprint 5 — Aprendizaje continuo y persistente

### Terminado

- Estado local persistente con `SharedPreferencesAsync`: misión y bloque actual,
  respuestas, completadas, minutos, conceptos, modo, repaso y favoritos.
- Restauración del punto exacto después de cerrar y volver a abrir la aplicación.
- Modo esencial e intensivo; intensivo seleccionado y recordado por defecto.
- Misiones 003 «Qué es un LLM», 004 «Tokens y ventana de contexto» y 005
  «Cómo construir prompts profesionales», con contenido real en `knowledge/`.
- Cinco misiones con desbloqueo secuencial y evaluaciones de ocho preguntas.
- Progreso centrado en misiones, horas, conceptos dominados, revisión y próxima meta.
- Autoevaluación: Entendido, Necesito repasar y Todavía no lo entendí.
- Manual ampliado y diccionario con quince términos en total.

### Calidad y entregables

- `flutter analyze`: sin problemas; 13 pruebas aprobadas.
- APK ARM64: `releases/Aprender IA 1.4.apk`.
- APK de validación x86_64 y capturas reales: `screenshots/sprint5-*.png`.

### Estado

Sprint 5 cerrado. Sprint 6 no iniciado.

## Sprint 6 — Biblioteca de pensamiento

- Biblioteca offline por temas, autores, ideas y conceptos relacionados.
- Seis autores y ocho temas iniciales; contenido rotulado como paráfrasis o
  interpretación editorial, sin citas inventadas ni imitación de voces.
- Buscador, filtros, favoritos y sección «Qué puedo aplicar yo».
- Contenido desacoplado en `knowledge/thought_library_v1.json` con validación.
- Calidad: `flutter analyze` limpio y suite de pruebas ampliada.

## Sprint 7 — Laboratorio de prompts

- Editor, plantillas guiadas, comparación original/mejorado y explicación.
- 20 ejercicios en siete categorías y tres niveles de dificultad.
- Evaluación local reutilizable basada en cinco reglas editoriales.
- Historial y favoritos persistentes; contrato preparado para comparaciones futuras.

## Sprint 8 — Mapa de conocimiento

- Mapa liviano derivado de misiones y conceptos, sin motor gráfico pesado.
- Estados: no visto, en aprendizaje, comprendido, necesita repaso y dominado.
- Cada concepto muestra precedentes, desbloqueos y acceso a su misión.
- Relaciones generadas desde contenido existente y cubiertas por pruebas.

## Sprint 9 — Experiencia diaria y Beta local

- Home diaria con recomendación, repaso, tiempo, meta semanal y próximo objetivo.
- Continuidad desde el último punto y modo intensivo predeterminado.
- Acceso integrado a Manual, Laboratorio, Mapa, Ideas, Catálogo y Diccionario.
- Beta local con versión visible, Acerca del proyecto, icono y splash provisionales.
- Exportación al portapapeles e importación validada de progreso JSON.
- Calidad final, APK ARM64 y validación visual de todos los módulos.
- APK final: `releases/Aprender IA 1.8 Beta.apk`; capturas reales:
  `screenshots/beta-*.png`.

### Pendientes propuestos para Sprint 10

- Pruebas en varios teléfonos físicos y accesibilidad con escalado de texto.
- Firma privada de distribución y automatización reproducible de releases.
- Revisión editorial con fuentes y autoría formal para ampliar la biblioteca.
- Evolución del almacenamiento si el historial supera el alcance de preferencias.
# Sprint 10 — Calidad Beta y distribución

**Estado:** finalizado.

- Recuperación centralizada ante rutas o contenido inválido.
- Importación de respaldo en dos pasos: validación, vista previa y confirmación.
- Diagnóstico local exportable sin respuestas ni datos personales.
- Versión, compilación y notas visibles.
- Diseño adaptable a pantallas angostas y escalado de texto hasta 200%.
- Script reproducible de APK ARM64 y guía de instalación.
- Prueba de recuperación de datos para la vista previa del respaldo.

Pendiente deliberado: publicación en Google Play.
# Sprint 11 — Misiones 006 a 015

**Estado:** finalizado.

- Diez misiones profesionales nuevas, versionadas en `knowledge/advanced_missions_v1.json`.
- Duraciones entre 55 y 75 minutos, modos esencial e intensivo soportados por el lector existente.
- Cada misión contiene al menos diez bloques, laboratorio, actividad de explicación o construcción y ocho preguntas.
- Misión 015 integra prompt profesional, selección de modelo, verificación y automatización conceptual.
- Validación editorial automática del número de bloques, preguntas, duración y conceptos.

Calidad: `flutter analyze` sin problemas; 21 pruebas aprobadas.
# Sprint 12 — Comparador de modelos

**Estado:** finalizado.

- Diez fichas de producto/modelo separadas del código.
- Comparación por nueve tareas con explicación de fortalezas, límites, privacidad y usos desaconsejados.
- Fecha de revisión, fuente y estado de verificación visibles.
- Campo de costo local editable, deliberadamente sin precio fijo para evitar datos obsoletos.
- Ejercicio de elección contextual en cada ficha.

Calidad: `flutter analyze` sin problemas; 23 pruebas aprobadas.
# Sprint 13 — Mentor por voz y experiencia personal

**Estado:** finalizado.

- Lectura de bloques con el motor de voz del dispositivo, control de velocidad, pausa y modo manos libres.
- Voz elegida por Android: no se clona ni imita a ninguna persona real.
- Reformulaciones locales: otra explicación, ejemplo difícil y aplicación bancaria.
- Perfil offline de Carlos con nivel, intereses, rol laboral, modo intensivo, prioridades y dificultad.
- Biblioteca ampliada con Geoffrey Hinton, Yann LeCun, Dario Amodei y Satya Nadella.
- Metadatos editoriales visibles para fuente, fecha, contexto y verificación.

Calidad: `flutter analyze` sin problemas; 25 pruebas aprobadas.

## Propuesta Sprints 14 a 17

1. **Sprint 14 — Evaluación de dominio:** respuestas abiertas, rúbricas locales y evidencia de transferencia.
2. **Sprint 15 — Accesibilidad validada:** pruebas con TalkBack, dispositivos físicos y auditoría WCAG móvil.
3. **Sprint 16 — Gobierno editorial:** flujo de revisión, caducidad de fuentes y firma de versiones de contenido.
4. **Sprint 17 — Release candidate:** firma privada, migraciones, telemetría opcional con consentimiento y preparación para tienda.
# Sprint 14 - Evaluación real del aprendizaje

**Estado:** finalizado.

- Evaluaciones abiertas para explicación, corrección de prompts, detección de errores, casos, construcción y comparación.
- Rúbrica local: comprensión, precisión, contexto, aplicación, pensamiento crítico y verificación.
- Devolución con aciertos, faltantes, mejora sugerida y ejemplo sólido.
- Advertencia explícita: la evaluación automática es orientativa, no perfecta.
- Marcado para revisión personal y pruebas de dominio tras misiones 005, 010 y 015.

Calidad: `flutter analyze` sin problemas; pruebas completas validadas tras corregir la expectativa editorial.
# Sprint 15 - Repaso inteligente

**Estado:** finalizado.

- Motor local que pondera errores, conceptos difíciles, antigüedad, pruebas marcadas y seguridad declarada.
- Sesiones de 5, 15 y 30 minutos.
- Tarjetas de recuerdo, preguntas, casos y corrección de prompts.
- Razón de selección y fecha de próxima aparición visibles.
- Persistencia compatible hacia atrás para errores, seguridad y último estudio.

Calidad: `flutter analyze` sin problemas; 30 pruebas aprobadas.
# Sprint 16 - Gobierno y calidad editorial

**Estado:** finalizado.

- Manifiesto editorial transversal con autor, versión, fechas, estado, fuentes, notas y próxima revisión.
- Validación de fechas, enlaces vacíos, afirmaciones actuales y citas textuales sin fuente.
- Detección automática de contenido vencido.
- Pantalla interna Estado del conocimiento.

Calidad: `flutter analyze` sin problemas; 32 pruebas aprobadas.
# Sprint 17 - Manual Maestro exportable

**Estado:** finalizado.

- Exportación offline en PDF, Markdown y HTML.
- Alcances: completo, capítulo, tema, favoritos y repaso.
- PDF con portada, índice, fecha, versión, paginación, glosario y fuentes.
- Modo lectura nocturna con texto entre 100% y 200%.
- PDF real generado y renderizado para control visual.

Calidad: `flutter analyze` limpio; 33 pruebas aprobadas.
# Sprint 18 - Constructor de proyectos

**Estado:** finalizado.

- Cinco proyectos profesionales completos y separados del código.
- Objetivos, conocimientos, misiones previas, pasos, entregables, criterios, riesgos y evaluación.
- Checklist interactivo y progreso por proyecto.

Calidad: `flutter analyze` limpio; 34 pruebas aprobadas.
# Sprint 19 - Camino profesional personalizado

**Estado:** finalizado.

- Ocho caminos con requisitos, habilidades, misiones, proyectos, horas y evaluación.
- Prioridad personalizada para Carlos: usuario avanzado, automatización, agentes, aplicaciones y banca/Excel.
- Progreso y conocimientos pendientes visibles.

Calidad: `flutter analyze` limpio; 35 pruebas aprobadas.

# Sprint 20 — Operación Pulido (Operation Polish)

**Estado:** finalizado.

- Unificación de componentes visuales en `app_theme.dart` (CardThemeData, ListTileThemeData, ChipThemeData, InputDecorationTheme, SegmentedButtonThemeData, SliderThemeData, SnackBarThemeData).
- Rediseño del menú "Explorar" en `CurrentMissionScreen` utilizando un GridView dinámico y limpio de 2 columnas.
- Refactorización, saneamiento y formateo de 6 archivos de presentación con código comprimido (`career_paths.dart`, `project_builder.dart`, `assessment_screen.dart`, `review_screen.dart`, `editorial_status_screen.dart`, `manual_export_screen.dart`).
- Reemplazo de espaciados fijos y ad-hoc por los tokens de espaciado del Design System (`AppSpacing`).
- Adopción de notificaciones interactivas Snackbars en importaciones, copias y exportaciones de datos.
- Resolución de advertencias de lints (orden de imports, variables deprecadas en inputs).

Calidad: `flutter analyze` limpio; 35 pruebas aprobadas de forma secuencial.

# Sprint 21 — Motor de Conocimiento (Knowledge Engine)

**Estado:** finalizado.

- Creación del `KnowledgeEngine` centralizado en `knowledge_engine.dart` que unifica la carga de recursos offline mediante assets locales.
- Reestructuración de la base de datos estática: fraccionamiento del archivo monolítico `oraculo_content_v1.json` en colecciones separadas para diccionario (`dictionary_v1.json`), manual (`manual_v1.json`) y 15 misiones pedagógicas individuales bajo `knowledge/missions/`.
- Creación del archivo curricular `modules_v1.json` que mapea la taxonomía de tracks, habilidades y competencias de `modules/academy`.
- Implementación de lazy loading en `SimulatedLessonRepository`: los bloques didácticos de las lecciones se cargan y parsean de forma diferida únicamente al entrar en su visualización, reduciendo el consumo de memoria.
- Validación automática y reporte de errores editoriales en el arranque, incluyendo:
  - Detección de enlaces rotos o huérfanos entre términos del diccionario.
  - Validación de límites de contenido para misiones avanzadas (mínimo 10 bloques y 8 preguntas).
  - Algoritmo de detección de ciclos en los prerrequisitos de las misiones usando búsqueda en profundidad (DFS).
- Integración de búsqueda indexada semántica rápida sobre manual y diccionario en caché de memoria.

Calidad: `flutter analyze` limpio; 36 pruebas unitarias aprobadas.

# Sprint 22 — Consolidación del Motor de Conocimiento (Knowledge Engine Consolidation)

**Estado:** finalizado.

- Extensión de `KnowledgeEngine` para unificar la carga de todos los archivos JSON restantes en `knowledge/`: cursos (`career_paths_v1.json`), proyectos (`projects_v1.json`), ejercicios de laboratorio (`prompt_exercises_v1.json`), biblioteca de pensamiento (`thought_library_v1.json`/`thought_library_expansion_v1.json`) y comparador de modelos (`model_catalog_v1.json`).
- Separación de modelos de dominio de entidades acopladas a la presentación (`CareerPath` y `LearningProject`) en archivos de dominio dedicados (`domain/career_path.dart` y `domain/learning_project.dart`), alineándose con la arquitectura de capas limpia.
- Refactorización de todos los lectores de catálogo y pantallas de interfaz para recuperar los datos cacheados y centralizados en `KnowledgeEngine.instance`, eliminando el uso redundante y directo de `rootBundle` y previniendo lecturas repetidas de disco.
- Implementación de reglas avanzadas de validación semántica cruzada en el arranque para garantizar que:
  * Todas las misiones listadas en cursos o proyectos correspondan a misiones existentes.
  * Todas las habilidades en las competencias y todas las competencias en los tracks taxonómicos existan.
- Ampliación de la suite de pruebas unitarias cubriendo todos los cargadores de datos curriculares y lógicos del motor.

Calidad: `flutter analyze` limpio; 36 pruebas unitarias aprobadas secuencialmente.

# Sprint 23 — Oráculo Creator Studio v1.0

**Estado:** finalizado.

- Diseño e implementación de **ORÁCULO Creator Studio**, un CMS interno offline para que el equipo editorial administre y verifique todo el contenido educativo en `knowledge/` de forma visual y robusta.
- Creación de un **Dashboard centralizado (Módulo 1)** con estadísticas de métricas clave (totales de cursos, misiones, manuales, laboratorios, proyectos, etc.) e indicadores del estado de la integridad semántica y revisiones pendientes.
- Implementación de editores visuales estructurados y específicos para cada entidad:
  - **Editor de Cursos (Módulo 2)**: Carga y guarda rutas de carrera en `career_paths_v1.json`.
  - **Editor de Misiones (Módulo 3)**: Edición de bloques instructivos interactivos, drag/drop conceptual con botones de movimiento (arriba/abajo), y edición detallada de quizzes. Guardado modular individual bajo `knowledge/missions/lesson-*.json`.
  - **Editor de Glosario (Módulo 4)**: Edición y creación de términos en `dictionary_v1.json`.
  - **Editor de Manual (Módulo 5)**: Creación de capítulos y artículos estructurados en `manual_v1.json`.
  - **Biblioteca de Pensamiento (Módulo 6)**: Registro de ideas y autores en `thought_library_v1.json` con validación estricta de fuentes para citas textuales.
  - **Editor de Laboratorios (Módulo 7)**: Creación de ejercicios prácticos de prompts en `prompt_exercises_v1.json`.
  - **Editor de Proyectos (Módulo 8)**: Administración de entregables, objetivos y rúbricas en `projects_v1.json`.
- Implementación de un **Validador en tiempo real (Módulo 9)** integrado en la UI que analiza conceptos huérfanos, enlaces rotos del glosario, preguntas sin respuestas válidas y capítulos de manual vacíos.
- **Exportador Directo a Disco (Módulo 10)**: Persiste los cambios formateados con sangría y espaciado estándar offline directo al árbol local de archivos.
- Creación de suite de pruebas unitarias y de integración `creator_studio_test.dart` y validación estática de compilación.

Calidad: `flutter analyze` limpio; 40 pruebas unitarias aprobadas secuencialmente.

# Sprint 24 — Oráculo Mentor Engine v1.0

**Estado:** finalizado.

- Diseño y desarrollo de la arquitectura de **ORÁCULO Mentor Engine v1.0**, un motor pedagógico offline integrado para acompañar al estudiante adaptativamente.
- **Perfil Pedagógico Completo (Módulo 1)**: Ampliación de `LearnerProfile` para albergar estadísticas de estudio, horas cursadas, conceptos dominados, conceptos débiles, objetivos, historial de puntuaciones y errores frecuentes.
- **Motor de Recomendaciones Basado en Reglas (Módulo 2)**: Recomienda de forma inteligente la siguiente actividad (misión, repaso, proyecto, lectura de manual) adaptada al progreso del perfil, explicando en español la justificación pedagógica de la elección.
- **Estilos Explicativos Alternativos (Módulo 3)**: Motor offline que genera explicaciones en 7 tonos distintos (Formal, Simple, Ejemplo Cotidiano, Ejemplo Técnico, Analogía, Paso a Paso, Resumen Ejecutivo) para conceptos clave de IA.
- **Dificultad Adaptativa (Módulo 4)**: Rúbricas lógicas que ajustan automáticamente la dificultad del perfil de usuario (Inicial, Intermedio, Exigente) ante aciertos y errores frecuentes en evaluaciones.
- **Memoria Pedagógica Local (Módulo 5)**: Registro persistente en memoria de explicaciones ya dadas, analogías utilizadas, laboratorios completados y sugerencias aceptadas.
- **Planificador Inteligente de Sesiones (Módulo 6)**: Generador dinámico de planes de estudio detallados ajustados a disponibilidad de tiempo (e.g. 15 minutos o 1 hora) y a la meta del alumno.
- **Contratos y Adaptadores de IA (Módulo 7)**: Interfaces desacopladas mediante el patrón Adapter para futuros conectores LLM remotos (OpenAI, Gemini, Claude, DeepSeek, Qwen, GLM, Llama, Mistral).
- **Panel Visual del Mentor (Módulo 8)**: Panel premium de control en Flutter donde el usuario ve fortalezas, debilidades, conceptos dominados/pendientes, y la recomendación personalizada del día.
- **Sistema de Eventos Didácticos (Módulo 9)**: Eventos internos (`MissionCompleted`, `ConceptLearned`, `ConceptFailed`, `ProjectStarted`, `ReviewCompleted`, `ManualRead`, `DictionaryViewed`) a los que el Mentor reacciona para actualizar el modelo del estudiante.
- Creación de pruebas unitarias robustas en `mentor_engine_test.dart` y validación estática de compilación limpia.

Calidad: `flutter analyze` limpio; 40 pruebas unitarias aprobadas secuencialmente.

# Sprint 25 — Oráculo Learning Engine v2

**Estado:** finalizado.

- Diseño y desarrollo del **Grafo No Lineal de Conocimiento (Módulo 1)**: Grafo multi-entidad donde cada nodo representa misiones, conceptos clave, laboratorios, proyectos evaluativos, términos del glosario o capítulos del manual, con sus prerrequisitos y dependencias.
- **Sistema de Prerrequisitos Críticos (Módulo 2)**: Validación inteligente que bloquea el acceso a misiones si el nivel de dominio de conceptos requeridos no está satisfecho, reportando retroalimentación clara de qué falta completar.
- **Progresión por Dominio Conceptual (Módulo 3)**: Niveles del 0 al 5 (No visto, Leído, Comprendido, Aplicado, Dominado, Enseñado) asociados de forma individual a cada concepto para independizar el progreso de la simple linealidad de las misiones.
- **Ruta Dinámica Personalizada (Módulo 4)**: Algoritmo heurístico que calcula la ruta diaria sugerida combinando el tiempo disponible, objetivos, dificultad y la presencia de bloqueos pedagógicos.
- **Transferencia Didáctica de Conocimientos (Módulo 5)**: Lógica cognitiva que modifica el tono didáctico si un concepto es revisitado, enlazándolo con el conocimiento previo en lugar de repetir explicaciones teóricas completas.
- **Detención Inteligente por Fallas (Módulo 6)**: Mecanismo de seguridad que bloquea el avance general si el alumno registra tres o más fallas consecutivas, forzando repasos conceptuales o laboratorios prácticos.
- **Evaluación Basada en Proyectos (Módulo 7)**: Validación de track curricular obligatorio que exige finalizar el proyecto integrador antes de poder desbloquear misiones avanzadas de automatización y agentes.
- **Árbol del Conocimiento Visual (Módulo 8)**: Rediseño completo de la interfaz de `KnowledgeMapScreen` para mostrar de forma interactiva el árbol de relaciones, niveles de dominio conceptual, prerrequisitos faltantes y cálculo de rutas del día.
- **Registro de Métricas Reales (Módulo 9)**: Dashboard analítico integrado en la UI que consolida métricas reales de estudio (horas invertidas, total de errores, repasos completados, cantidad de proyectos entregados y duración media de sesión).
- Creación de suite de pruebas unitarias robustas en `learning_engine_test.dart` y validación estática de compilación limpia.

Calidad: `flutter analyze` limpio; 40 pruebas unitarias aprobadas secuencialmente.
