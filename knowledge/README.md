# Knowledge base

El contenido offline publicado vive en `oraculo_content_v1.json`. Se eligió JSON
porque permite metadatos tipados, validación determinista, relaciones internas y
carga directa sin dependencias nuevas. `schemaVersion` habilita una evolución
explícita del formato y el lector informa errores editoriales antes de renderizar.

Fuente editorial de ORÁCULO IA. Este árbol contiene conocimiento versionable, no
código de ejecución. Cada colección tendrá su propio esquema, fuentes, autoría,
estado de revisión y versión de contenido.

El runtime empaqueta como asset el artefacto JSON validado de esta carpeta; los
widgets nunca contienen ni interpretan contenido educativo directamente.
