# Revisión arquitectónica — Sprint 0.5

## Alcance

Auditoría de dependencias, límites de módulos y riesgos de crecimiento. Este
documento propone decisiones futuras; no autoriza su implementación en Sprint 0.5.

## Estado saludable

- Las features no se importan entre sí.
- `app/router` compone pantallas mediante callbacks e IDs simples.
- `bootstrap` es el único lugar que conoce implementaciones de repositorios.
- Los modelos de dominio no dependen de Flutter, Riverpod, SQLite o Firebase.
- `academy` y `learning_engine` pueden extraerse como paquetes Dart sin cambiar sus
  contratos públicos.
- El conocimiento editorial está separado del código de ejecución.
- La UI tiene internacionalización desde el inicio.

## Dependencias innecesarias o mejorables

### `AsyncContent` depende de Riverpod

El design system conoce `AsyncValue<T>`. Esto simplifica hoy la UI, pero acopla un
componente visual al gestor de estado. Si Riverpod cambia, o si otro consumidor no lo
usa, el componente deja de ser reutilizable.

**Propuesta futura:** recibir un estado visual propio (`loading`, `data`, `error`) o
separar el adaptador Riverpod del componente visual.

### El contenido educativo está temporalmente en ARB

ARB es apropiado para textos de interfaz, no para lecciones versionadas. Mantener
explicaciones y ejercicios allí dificultaría autoría, fuentes, revisión y versiones.

**Propuesta futura:** mover contenido pedagógico a artefactos publicados desde
`knowledge/`; dejar ARB sólo para la interfaz.

### Los contratos de repositorio están registrados desde presentación

Los providers que exponen repositorios viven actualmente en `presentation`. El
dominio no depende de Riverpod, pero la ubicación puede hacer que `bootstrap` importe
detalles de presentación para inyectar infraestructura.

**Propuesta futura:** crear una capa de composición por módulo o adaptadores de DI
fuera de `presentation`, cuando existan más repositorios.

## Cuellos de botella futuros

### Estado dentro de `Mission`

`Mission.status` mezcla definición curricular con estado personal. Una misión puede
estar disponible para un alumno y bloqueada para otro.

**Resuelto en Sprint 1:** `Mission` ya no contiene estado personal.

**Propuesta futura:** mantener `Mission` como definición inmutable y mover el estado
a `MissionAssignment` o `LearnerMissionState` dentro del contexto del alumno.

### Identificadores primitivos

Los módulos usan `String` para permanecer desacoplados. Al crecer, puede confundirse
un `missionId` con un `skillId` sin que el compilador lo detecte.

**Propuesta futura:** introducir value objects pequeños por módulo y serializarlos en
sus límites. No crear una jerarquía global de IDs.

### Duplicación entre secuencias y prerrequisitos

`MissionSequence`, `Mission.prerequisiteIds` y futuras reglas del motor podrían
describir órdenes contradictorios.

**Propuesta futura:** declarar una fuente curricular canónica y definir qué reglas
son restricciones duras frente a preferencias de selección.

### Router y bootstrap monolíticos

Son correctos para el tamaño actual, pero crecerán linealmente con cada módulo. Un
archivo global muy grande aumenta conflictos y conocimiento centralizado.

**Propuesta futura:** permitir que cada módulo exponga una composición pequeña de
rutas y dependencias; el nivel app sólo las ensambla. No hacerlo hasta que el tamaño
lo justifique.

### Contratos del Learning Engine demasiado estables demasiado pronto

Los contratos nuevos expresan límites, no algoritmos validados. Convertirlos en API
inamovible antes de probar decisiones reales puede fijar supuestos equivocados.

**Propuesta futura:** versionar decisiones y conservar explicabilidad; evolucionar
los contratos a partir de casos pedagógicos reales antes de extraerlos a un paquete.

### Tiempo y determinismo

Algunos modelos usan `DateTime` directamente. Rachas, revisiones y sincronización
serán sensibles a reloj, zona horaria y cambios de dispositivo.

**Propuesta futura:** introducir `Clock`, día lógico del alumno y política explícita
de zona horaria antes de implementar rachas o repetición espaciada.

### Evolución y serialización de modelos

Los modelos todavía no definen igualdad, esquema de serialización ni migración. No
es un problema sin persistencia, pero lo será al incorporar contenido versionado.

**Propuesta futura:** definir DTOs separados, migraciones y pruebas de compatibilidad
cuando se elija persistencia. No agregar serialización al dominio por anticipado.

### Errores sin taxonomía

Los casos de uso dependen hoy de excepciones genéricas y la UI muestra errores
generales. Con almacenamiento, red y contenido, esto limitará recuperación y soporte.

**Propuesta futura:** diseñar fallos de dominio tipados y observabilidad sin exponer
errores técnicos al alumno.

### Conocimiento editorial sin esquema ejecutable

`knowledge/` tiene taxonomía pero aún no posee schemas, validación, fuentes ni flujo
de publicación.

**Propuesta futura:** antes de cargar contenido masivo, definir esquema versionado,
metadatos obligatorios, validación automática y proceso de revisión editorial.

## Mejoras propuestas, no implementadas

1. Separar definición de misión de estado del alumno.
2. Diseñar el pipeline `knowledge -> validación -> paquete de contenido -> runtime`.
3. Extraer Riverpod del design system visual.
4. Crear composición modular sólo cuando router o bootstrap superen un tamaño útil.
5. Introducir IDs tipados en los límites con mayor riesgo de confusión.
6. Definir `Clock` y política temporal antes de rachas o revisiones.
7. Definir errores tipados antes de red o persistencia.
8. Establecer pruebas de contratos para futuras implementaciones de repositorios.
9. Mantener Learning Engine explicable y determinista antes de cualquier IA.
10. Adoptar reglas automáticas de dependencias para impedir imports entre módulos.

## Criterios arquitectónicos para Sprint 1

Antes de comenzar, conviene decidir únicamente lo necesario para ese sprint:

- cuál será el caso de uso vertical completo;
- qué estado pertenece al alumno y qué estado al catálogo;
- cómo se representa un error recuperable;
- qué parte del contenido sigue simulada;
- cómo se comprobarán límites modulares en CI.
