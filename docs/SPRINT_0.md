# Sprint 0 — Fundación

## Alcance entregado

- Proyecto Flutter con reglas estrictas de análisis.
- Tema oscuro Material 3.
- Navegación declarativa.
- Splash con resolución de primera apertura.
- Bienvenida con persistencia local.
- Mi misión como destino principal y única acción primaria.
- Internacionalización ARB desde el primer commit.
- Dominio central `Mission` y contrato de repositorio independiente.
- Árbol editorial `knowledge/` separado del runtime.
- Separación inicial de dominio, datos y presentación.
- Pruebas unitarias y de widget iniciales.
- Navegación estructural hasta Lección y Progreso sin lógica avanzada.
- Repositorio de misiones simulado detrás de un contrato reemplazable.
- Modelos iniciales de lección, intento y progreso.

El botón `CONTINUAR MI MISIÓN` queda deliberadamente sin navegación hasta que el
flujo **Mi misión -> Lección** se implemente en Sprint 1.

## Riesgos detectados y mitigación

| Riesgo | Impacto | Mitigación |
| --- | --- | --- |
| Contenido sin estrategia editorial | Misiones inconsistentes | Definir esquema versionado y revisión pedagógica antes de cargar catálogo. |
| Racha basada en reloj del dispositivo | Fraude o errores de zona horaria | Guardar día lógico y zona; validar en servidor al sincronizar. |
| SQLite y Firebase como dos fuentes de verdad | Conflictos y pérdida de progreso | SQLite local-first; servidor como réplica con IDs y timestamps estables. |
| Gamificación prematura | Incentiva XP sobre aprendizaje | XP sólo tras evidencias de finalización y métricas de retención. |
| Menú no alineado con las 7 pantallas | Navegación confusa | Tratar Academia, Prompts y Modelos IA como destinos editoriales incrementales. |
| Nombre y contenido hardcodeados | Bloquea personalización | Sustituir por perfil y repositorio de misiones en Sprint 1. |
| SDK no fijado | Builds diferentes | Adoptar FVM y CI cuando el SDK esté disponible. |

## Mejoras propuestas sin ampliar el MVP

1. Definir una misión como unidad versionada: objetivo, lección, ejercicio, duración y prerequisitos.
2. Hacer la experiencia offline-first desde el primer repositorio SQLite.
3. Medir activación, misión iniciada/completada y retorno al día siguiente.
4. Incorporar accesibilidad (escalado de texto, contraste y lectores de pantalla) como criterio de aceptación.
5. Agregar Firebase sólo detrás de interfaces cuando exista login/sincronización real.

## Criterio para iniciar Sprint 1

- Aprobar arquitectura y alcance.
- Instalar Flutter estable o indicar su ubicación.
- Confirmar que Sprint 1 abarcará `Lección`, modelo local SQLite y flujo de finalización.
