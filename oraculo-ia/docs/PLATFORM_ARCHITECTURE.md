# Arquitectura de plataforma

## 1. Centro del sistema

`Mission` es el agregado que organiza la experiencia diaria. Una pantalla es sólo
una representación de su estado.

```text
Learner -> Current Mission -> Lesson -> Exercise -> Completion -> Progress
                    ^                                      |
                    +----------- Next Mission -------------+
```

La plataforma decide la misión actual a partir del progreso, prerrequisitos y
reglas pedagógicas. La interfaz presenta una única acción primaria: continuarla.

## 2. Árbol objetivo completo

```text
oraculo_ia/
├── knowledge/                       # conocimiento editorial; nunca código
│   ├── agents/
│   ├── automation/
│   ├── benchmarks/
│   ├── missions/
│   ├── models/
│   ├── news/
│   ├── prompts/
│   └── thinkers/
├── docs/
├── lib/
│   ├── l10n/                        # catálogos ARB
│   ├── main.dart
│   └── src/
│       ├── app/                     # composición, router y tema
│       ├── bootstrap/               # inyección en el composition root
│       ├── core/                    # primitives futuras, sólo con uso real
│       ├── design_system/           # componentes visuales reutilizables
│       │   ├── components/
│       │   └── foundations/
│       ├── modules/
│       │   ├── academy/             # taxonomía curricular pura
│       │   └── learning_engine/     # contratos de decisión pedagógica
│       └── features/
│           ├── onboarding/
│           │   ├── data/
│           │   ├── domain/
│           │   └── presentation/
│           ├── missions/
│           │   ├── data/
│           │   ├── domain/
│           │   └── presentation/
│           ├── lessons/
│           │   ├── domain/
│           │   └── presentation/
│           ├── progress/
│           │   ├── domain/
│           │   └── presentation/
│           └── profile/             # posterior al flujo esencial
├── test/                             # refleja lib/src por feature
├── integration_test/
├── l10n.yaml
└── pubspec.yaml
```

Sólo se crean carpetas de código cuando contienen una responsabilidad real. El
árbol muestra el destino arquitectónico; no se agregan abstracciones vacías.

## 3. Regla de módulos

Cada feature expone contratos de dominio y mantiene privados sus detalles de datos
y presentación. No puede importar otra feature. La coordinación ocurre mediante:

1. casos de uso de aplicación en el composition root;
2. IDs estables, no objetos de otro módulo;
3. eventos de dominio para efectos posteriores;
4. interfaces pequeñas ubicadas en el módulo que las consume.

`core` no es un cajón de utilidades: sólo admite primitives realmente compartidas.
`design_system` puede depender de Flutter, pero nunca de una feature.

## 4. Modelo de dominio

### Mission

| Campo | Tipo | Responsabilidad |
| --- | --- | --- |
| `id` | UUID/string estable | Identidad lógica permanente. |
| `contentVersion` | integer | Versión editorial reproducible. |
| `lessonId` | ID | Referencia a contenido, sin importar el módulo Lesson. |
| `title` | string localizado | Contenido resuelto por locale por el repositorio. |
| `sequence` | integer | Orden curricular. |
| `estimatedMinutes` | integer | Expectativa transparente de esfuerzo. |
| `prerequisiteIds` | lista de ID | Condiciones pedagógicas. |

El estado de una misión pertenece al alumno, no a esta definición curricular.

### Lesson

`id`, `contentVersion`, `title`, bloques ordenados (`explanation`, `example`,
`exercise`, `summary`) y duración. El contenido se versiona; no se sobrescribe una
lección que ya fue cursada.

### LearnerProgress

`learnerId`, `currentMissionId`, `completedMissionIds`, `xp`, `level`,
`studySeconds`, `logicalStudyDay`, `streak`, `lastActivityAt` y `updatedAt`.

### MissionAttempt

`id`, `missionId`, `missionContentVersion`, `startedAt`, `completedAt`,
`studySeconds`, `exerciseEvidence` y `syncState`. Este registro inmutable permite
auditoría, reintentos y cálculo de progreso sin depender de contadores frágiles.

## 5. Persistencia

SQLite será la fuente local de verdad en una versión posterior. El esquema previsto
incluye:

- `missions`
- `lessons`
- `mission_prerequisites`
- `mission_attempts`
- `learner_progress`

`sync_outbox` se agregará únicamente cuando exista sincronización remota.

Sprint 1 no implementa persistencia. Una futura `sync_outbox` permitirá sincronizar
sin acoplar los repositorios a Firebase ni perder operaciones offline.

El contenido en `knowledge/` pasa por validación editorial y un proceso de build
genera paquetes versionados importables a SQLite.

## 6. Navegación inicial

```text
Splash
  ├── primera apertura -> Bienvenida -> Mi misión
  └── alumno conocido ----------------> Mi misión

Mi misión -> Lección -> Progreso -> Mi misión siguiente
```

No habrá shell, menú inferior ni rutas de Academia, Prompts o Modelos en este
flujo. La ruta de destino siempre deriva del estado de la misión, no de una pantalla
elegida arbitrariamente.

## 7. Componentes reutilizables propuestos

### Design system

- `OraculoScaffold`: área segura, ancho máximo y espaciado consistente.
- `PrimaryMissionAction`: única acción primaria, estados loading/disabled y semántica.
- `MissionHeader`: contexto breve de la misión actual.
- `ContentSection`: título y bloque accesible para explicación, ejemplo y resumen.
- `ProgressIndicator`: avance dentro de la misión, no navegación global.
- `AsyncContent`: loading, error recuperable y contenido sin duplicar lógica visual.

### Lógica compartida

- `Clock`: tiempo inyectable para rachas y pruebas.
- `Result<T>`: éxito/fallo tipado sin excepciones cruzando capas.
- `IdGenerator`: IDs locales estables.
- `TransactionRunner`: límite transaccional independiente de SQLite.

Ya existen `OraculoScaffold`, `PrimaryMissionAction`, `AsyncContent` y tokens de
espaciado porque tienen uso inmediato. Las primitives de lógica se implementarán
al aparecer en dos usos reales o cuando definan una frontera crítica.

## 8. Internacionalización

Los textos de UI viven en ARB y el código usa claves generadas. El repositorio de
contenido entrega la versión localizada de cada misión o lección. Español es el
locale inicial y el fallback editorial; añadir otro idioma no cambia el dominio.

## 9. Estado de la implementación estructural

Implementado:

- rutas Splash, Bienvenida, Mi misión, Lección y Progreso;
- modelos `Mission`, `Lesson`, `MissionAttempt` y `LearnerProgress`;
- contrato `MissionRepository` y caso de uso `GetCurrentMission`;
- repositorios simulados de misión y lección inyectados desde `bootstrap`;
- ViewModel asíncrono para la misión actual;
- finalización y progreso simulados en memoria;
- tema oscuro Material 3 y componentes visuales mínimos;
- internacionalización ARB.

Deliberadamente pendiente después de Sprint 1:

- XP, nivel, racha o medición real de tiempo;
- persistencia local y migraciones;
- selección pedagógica de la siguiente misión;
- ejercicios interactivos;
- sincronización y Firebase;
- analítica y autenticación.
