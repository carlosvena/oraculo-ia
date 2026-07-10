# Arquitectura

La arquitectura vigente se documenta en
[`PLATFORM_ARCHITECTURE.md`](PLATFORM_ARCHITECTURE.md).

La decisión rectora es que `Mission`, y no una pantalla, es el centro del sistema.
Cada funcionalidad es un módulo independiente y `knowledge/` se mantiene separado
del código de ejecución.

