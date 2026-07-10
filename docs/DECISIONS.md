# Decisiones del proyecto

## ADR-001 — Mission First

**Estado:** aceptada.

`Mission` es la unidad central del producto. Las pantallas representan el estado de
la misión; no organizan el dominio.

## ADR-002 — Módulos sin dependencias cruzadas

**Estado:** aceptada.

Las features no se importan entre sí. Router y bootstrap son puntos de composición.
Esto permite reemplazar implementaciones sin reescribir el dominio.

## ADR-003 — Sprint 1 completamente simulado

**Estado:** aceptada por Product Owner.

Misión, lección y progreso viven en memoria. Se prioriza evaluar la experiencia antes
de elegir persistencia, Firebase o IA.

## ADR-004 — Internacionalización desde el inicio

**Estado:** aceptada.

Los textos de interfaz usan ARB. Los archivos Dart generados se conservan en el
proyecto porque OneDrive impide que `gen-l10n` reemplace temporales durante el build.
La generación reproducible se realiza desde una copia temporal fuera de OneDrive.

## ADR-005 — Build Android fuera de OneDrive

**Estado:** aceptada como solución operativa, no arquitectónica.

OneDrive aplica ACL que impiden a Flutter borrar ciertos directorios de build. La
fuente permanece en el workspace y compilación/pruebas se ejecutan en una copia
temporal. Los artefactos finales vuelven a `releases/`.

## ADR-006 — Límites de memoria de Gradle

**Estado:** aceptada.

Se limita Gradle a 1536 MB, un worker y Kotlin daemon a 512 MB. El template de Flutter
reservaba 8 GB y fallaba por el tamaño del archivo de paginación del equipo.

## ADR-007 — Nombre de los APK de revisión

**Estado:** aceptada por Product Owner.

Los entregables se nombran `Aprender IA 1.apk`, `Aprender IA 1.1.apk`,
`Aprender IA 1.2.apk`, etc. Este nombre identifica revisiones instalables y es
independiente del versionado técnico interno y del nombre comercial ORÁCULO IA.

## Decisión pendiente para revisión

La versión 0.1 necesita una estrategia de persistencia. No se implementará hasta que
Product Owner apruebe alcance y experiencia del Sprint 1.
