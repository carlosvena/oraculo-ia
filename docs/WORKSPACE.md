# Workspace Personal Offline — Arquitectura y Estructura

Este documento detalla el diseño técnico y la implementación del Workspace Personal (`lib/src/features/workspace/`) de ORÁCULO IA.

---

## 1. Capa de Dominio (Modelos de Datos)
El dominio del Workspace está modelado en `workspace_models.dart` con clases inmutables preparadas para serialización JSON:

- **`WorkspaceNote`**:
  - `id`: Identificador único secuencial (`note-${timestamp}`).
  - `title`: Título de la nota (por defecto 'Nota sin título').
  - `body`: Cuerpo del documento con sintaxis markdown.
  - `tags`: Etiquetas asociadas.
  - `updatedAt`: Sello de fecha de la última actualización.
- **`WorkspacePrompt`**:
  - `id`: Identificador único (`prompt-${timestamp}`).
  - `title`: Nombre descriptivo del prompt.
  - `promptText`: Estructura del metaprompt.
  - `tags`: Lista de etiquetas de clasificación.
  - `version`: Entero secuencial que incrementa +1 al guardar ediciones.
  - `isFavorite`: Bandera booleana de favorito.
  - `relatedConcepts`: Conceptos curriculares del manual o cursos vinculados.
- **`WorkspaceExperiment`**:
  - `id`: Identificador.
  - `objective`: Propósito del experimento.
  - `hypothesis`: Hipótesis planteada.
  - `promptText`: Metaprompt de entrada.
  - `result`: Resultados observados.
  - `learning`: Lecciones clave.
  - `nextSteps`: Próximos pasos de mejora.
- **`WorkspaceDocument`**:
  - `id`: Identificador.
  - `title`: Título.
  - `content`: Contenido de texto.
  - `category`: Clasificación sectorial (`IA`, `Trabajo`, `Banco`, `Excel`, `Programación`, `Personal`).

---

## 2. Capa de Datos (Persistencia y Repositorio)
La persistencia de datos es 100% local, utilizando `SharedPreferences`:
- **Clase `WorkspaceRepository`**:
  - Centraliza el acceso y las operaciones síncronas de lectura sobre memoria intermedia.
  - Escribe asíncronamente en local bajo claves individuales como `ws_notes_v1`, `ws_prompts_v1`, `ws_favorites_v1`.
  - Expone funciones utilitarias de generación de respaldos y restauración.
- **Notifier `WorkspaceStateNotifier`**:
  - Gestiona el estado reactivo (`WorkspaceState`) y propaga los cambios a la interfaz de usuario.
  - Realiza operaciones de guardado y eliminación notificando instantáneamente a los escuchas.

---

## 3. Mecanismo de Autoguardado (Notebook)
- En la pantalla `NotebookScreen`, al abrir una nota se inicializa un `Timer.periodic` de Flutter que se ejecuta cada 4 segundos.
- Llama a `_saveCurrentNote()`, el cual verifica si ha habido modificaciones y las persiste localmente de manera silenciosa sin interrumpir el foco de escritura del usuario.
- Al salir del editor (retroceder) o cambiar al modo vista previa, se ejecuta una llamada final de guardado síncrono.

---

## 4. Respaldos Criptográficos (SHA-256)
- **Generación de Backup**:
  - Agrupa todas las colecciones del espacio del usuario en un mapa JSON.
  - Genera un hash `sha256` del string serializado del payload.
  - Empaqueta el hash en un campo `checksum` junto al `payload` de datos.
- **Validación al Importar**:
  - Al recibir una cadena de respaldo, calcula el hash `sha256` sobre el `payload` recibido.
  - Compara el hash calculado con el `checksum` provisto.
  - Si no coinciden, aborta la operación y retorna un error, evitando cargar datos corruptos o truncados en el dispositivo del usuario.
