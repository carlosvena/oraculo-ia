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
