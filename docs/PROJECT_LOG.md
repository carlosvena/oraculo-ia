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
