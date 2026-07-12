# AUDITORÍA DE INTEGRACIÓN INICIAL — ANTIGRAVITY

Este documento contiene la auditoría del estado real del proyecto **ORÁCULO IA** realizada por Antigravity. El objetivo es confirmar que la integración inicial es segura y proponer la distribución de tareas y el plan de trabajo para los próximos sprints.

---

## 1. Estado Actual del Proyecto

El proyecto se encuentra en un estado maduro y estable para una aplicación *local-first*, habiendo completado 19 sprints de desarrollo educativo, curricular y de herramientas sin conexión.

- **Último Sprint completado:** Sprint 19 (Camino profesional personalizado).
- **Estructura del Repositorio:** Limpia y alineada con la arquitectura `feature-first` descrita en [PLATFORM_ARCHITECTURE.md](file:///C:/Users/carlo/.gemini/antigravity/scratch/oraculo-ia/docs/PLATFORM_ARCHITECTURE.md).
- **Código Fuente:** Ubicado bajo [lib/src/](file:///C:/Users/carlo/.gemini/antigravity/scratch/oraculo-ia/lib/src/).
- **Contenido Editorial:** Separado de manera robusta del código fuente, ubicado en archivos JSON estructurados en la carpeta [knowledge/](file:///C:/Users/carlo/.gemini/antigravity/scratch/oraculo-ia/knowledge/).
- **Rama Actual de Trabajo:** `antigravity/integracion-inicial` (derivada de `master`).
- **Estado del Árbol de Trabajo:** Limpio (`nothing to commit, working tree clean`).

---

## 2. Versión de Flutter y Dart

Tras localizar los ejecutables provistos en el entorno del sistema, se obtuvieron las siguientes especificaciones técnicas oficiales:

- **Versión de Flutter:** `3.44.6` (Channel: `stable`, revisión: `ee80f08bbf`).
- **Versión de Dart:** `3.12.2`.
- **Motor de Renderizado:** Engine hash `d3a3293399556a85388faf8c6f0723a7a5597aa8`.
- **Versión de DevTools:** `2.57.0`.

---

## 3. Estado de la Suite de Pruebas y Análisis Estático

### Análisis Estático (`flutter analyze`)
- **Resultado:** **Limpio (No issues found!)**
- **Configuración:** Sigue las reglas estrictas definidas en [analysis_options.yaml](file:///C:/Users/carlo/.gemini/antigravity/scratch/oraculo-ia/analysis_options.yaml).

### Suite de Pruebas Unitarias (`flutter test`)
- **Cantidad de Pruebas:** **35 pruebas unitarias automatizadas.**
- **Resultado:** **Aprobadas (All tests passed!)**
- **Comportamiento Crítico en este Entorno:** 
  - La suite de pruebas experimenta fallas por falta de memoria del compilador de Dart (`Out of memory` en `vm/heap/pages.cc` o `allocation.cc`) cuando se ejecuta con concurrencia por defecto en este entorno restringido.
  - **Solución implementada:** Se debe ejecutar la suite de pruebas de forma secuencial restringiendo el número de hilos con:
    ```bash
    flutter test -j 1
    ```
    Bajo esta modalidad, las 35 pruebas pasan de forma exitosa y consistente.

---

## 4. Revisión de Dependencias y Seguridad

### Dependencias Principales ([pubspec.yaml](file:///C:/Users/carlo/.gemini/antigravity/scratch/oraculo-ia/pubspec.yaml))
El ecosistema es liviano y no posee exceso de librerías de terceros:
- `flutter_riverpod` (^3.3.2) para el manejo de estado.
- `go_router` (^17.3.0) para la navegación declarativa y segura.
- `shared_preferences` (^2.5.5) para persistencia clave-valor simple.
- `flutter_tts` (^4.2.5) para el motor de lectura por voz.
- `pdf` (^3.11.3) para la generación offline del Manual Maestro.
- `path_provider` (^2.1.5) para interactuar con el sistema de archivos local.

### Auditoría de Secretos y Credenciales Accidentales
- Se ejecutó un análisis léxico recursivo en todos los archivos de código y recursos editoriales del proyecto buscando patrones clave como `api_key`, `secret`, `password`, `token` y `credential`.
- **Resultado:** **No se detectaron secretos ni credenciales expuestas.**
- Las coincidencias encontradas corresponden exclusivamente a contenido didáctico explicativo (por ejemplo, definiciones semánticas del término "Token", explicaciones de RAG, o el texto traducido "Reglas secretas de Internet").

### Verificación de APK y Documentación
- La carpeta [releases/](file:///C:/Users/carlo/.gemini/antigravity/scratch/oraculo-ia/releases/) contiene el archivo `ORACULO IA - Manual Maestro 2.6.pdf` (5.8 KB) generado durante las validaciones de exportación.
- Los APKs release descritos en los logs históricos de sprints (como `releases/Aprender IA 1.8 Beta.apk`) están correctamente ignorados en el archivo `.gitignore` para evitar saturar el repositorio git con binarios.

---

## 5. Riesgos Detectados

1. **Restricción de Memoria en el Entorno Local:** La máquina del desarrollador/sandbox cuenta con límites de memoria física. Si se ejecutan múltiples tareas en paralelo (como compilaciones simultáneas de APK o suites de pruebas concurrentes), el sistema de asignación de memoria de Dart/Gradle falla. Las pruebas automatizadas y compilaciones deben realizarse con límites estrictos de concurrencia.
2. **Entorno de Path No Configurado:** Ni Git ni Flutter se encuentran disponibles de manera global en el `%PATH%` del sistema operativo. Es necesario invocar las herramientas a través de sus rutas absolutas o de lo contrario las automatizaciones fallarán:
   - **Git:** `C:\Users\carlo\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\cmd\git.exe`
   - **Flutter:** `C:\Users\carlo\AppData\Local\Codex\tools\flutter\bin\flutter.bat`
3. **Escalabilidad de Almacenamiento Local (KeyValue):** El proyecto ha crecido hasta incluir 19 sprints y múltiples módulos de repaso, proyectos y perfiles de usuario. Actualmente, la persistencia reside en preferencias asíncronas (`SharedPreferencesAsync`). Si el historial de laboratorios o intentos de misiones crece sustancialmente, se corre el riesgo de degradación de velocidad y fragmentación de datos. Se requerirá la migración planificada a SQLite.

---

## 6. Distribución de Tareas: Antigravity vs. Codex

Dadas las capacidades y la integración de cada agente, se propone la siguiente división de responsabilidades para optimizar el trabajo conjunto:

### Tareas que Antigravity puede asumir de forma autónoma
- **Desarrollo Arquitectónico y Modular:** Creación de nuevas features siguiendo el patrón modular feature-first y desacoplamiento de capas de dominio.
- **Implementación de Lógica y Algoritmos Locales:** Motores de recomendación pedagógica, repasos espaciados o algoritmos de validación editorial.
- **Accesibilidad (WCAG) y UI:** Ajuste de diseño Material 3, rotulación semántica para TalkBack/VoiceOver, soporte a fuentes dinámicas y adaptabilidad móvil.
- **Pruebas de Calidad:** Escritura y mantenimiento de la suite de pruebas unitarias y de widgets.
- **Validaciones de Gobierno Editorial:** Scripts de análisis de integridad en `knowledge/`.

### Tareas que deberían reservarse para Codex
- **Resolución de Problemas del Compilador y Entorno Físico:** Depuración de fallas de dependencias Gradle de bajo nivel, configuraciones específicas de firmas de producción (`keystores`), configuraciones complejas de hardware de audio en Android.
- **Optimizaciones de Rendimiento del Motor Dart VM:** Ajustes internos ante crashes de memoria en el runner o integración directa con APIs nativas (NDK).

---

## 7. Propuesta de Trabajo para los Sprints 20 a 23

### Sprint 20 — Seguridad, Encriptación y Respaldo Remoto Seguro
- **Objetivo:** Proteger el progreso y las notas del usuario localmente y habilitar una sincronización remota transparente y segura.
- **Tareas:**
  - Migrar la persistencia sensible a almacenamiento local encriptado (utilizando `flutter_secure_storage` o envoltorios criptográficos sobre SharedPreferences).
  - Diseñar el contrato e interfaz de sincronización opcional con un backend en la nube (Supabase o Firebase), manteniendo la aplicación operativa 100% offline.
  - Implementar validación criptográfica en la importación de respaldos para evitar inyección de progreso inválido.

### Sprint 21 — Accesibilidad Validada (WCAG Móvil)
- **Objetivo:** Garantizar que ORÁCULO IA pueda ser utilizado sin barreras por cualquier alumno.
- **Tareas:**
  - Auditoría de accesibilidad TalkBack/VoiceOver: asegurar etiquetas semánticas y orden de enfoque consistente en todos los bloques didácticos de `LessonBlock`.
  - Asegurar contraste semántico en modo oscuro según lineamientos WCAG AAA.
  - Validar y asegurar que el diseño responde correctamente al escalado de texto del sistema operativo hasta un 200% sin desbordes.

### Sprint 22 — Rendimiento a Escala: Migración a Base de Datos SQLite
- **Objetivo:** Sustituir la persistencia clave-valor fragmentada por un motor relacional local robusto.
- **Tareas:**
  - Definir el esquema relacional local definitivo (tablas para `learner_progress`, `mission_attempts`, `thought_library`, etc.).
  - Implementar la migración de datos hacia `drift` (o `sqflite`) sin pérdida de información para los usuarios que actualicen la versión.
  - Optimizar la carga de contenido editorial parseando y cacheando las misiones de forma incremental en SQLite en lugar de decodificar grandes JSONs en memoria al inicio.

### Sprint 23 — Automatización de Releases y Release Candidate
- **Objetivo:** Preparar la aplicación para su publicación oficial.
- **Tareas:**
  - Implementar un pipeline local reproducible de firmas release utilizando variables de entorno protegidas.
  - Optimización del tamaño del APK final (configuración de ProGuard/R8, división de recursos por arquitectura de CPU - ARM64/ARMv7/x86_64).
  - Pantalla interna de diagnóstico extendido para soporte y preparación de metadatos finales para la tienda de aplicaciones.
