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

### Pendiente al cierre

- Persistencia real: el estado se reinicia al cerrar el proceso.
- Compilar el artefacto acumulado después del pulido de Sprint 4.

### Próximo paso automático

Sprint 3: consolidar la estructura educativa reutilizable.
