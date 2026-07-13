# GUÍA DE ESTILOS Y COMPONENTES (DESIGN SYSTEM) — ORÁCULO IA

Este documento describe la base visual y las directrices de interfaz de usuario de **ORÁCULO IA**. Su objetivo es garantizar la consistencia, limpieza estética y accesibilidad en futuras iteraciones del proyecto.

---

## 1. Fundamentos Visuales

### Paleta de Colores (Material 3 Dark)
La aplicación es exclusivamente oscura (*dark-first*), diseñada para evitar la fatiga visual nocturna:

| Token Semántico | Color Hex | Propósito Visual |
| :--- | :--- | :--- |
| **Primary (Seed)** | `#8B7CFF` | Botones de acción principales, acentos de estado activo, iconos clave. |
| **Background** | `#0B0B0F` | Fondo principal de la aplicación (scaffolds). |
| **Surface** | `#17171D` | Fondo de tarjetas (Cards), campos de texto e inputs. |
| **Primary Container** | `#8B7CFF` (35% alpha) | Indicadores de progreso y chips de selección activa. |
| **Outline Variant** | `#FFFFFF` (15% alpha) | Bordes sutiles para tarjetas y divisores de separación. |
| **Grey** | `#9E9E9E` | Subtítulos e información descriptiva secundaria. |

---

## 2. Tipografía y Jerarquía

Se utiliza la tipografía **Roboto** con pesos definidos semánticamente para asegurar legibilidad:

* **Títulos Principales (`headlineMedium`):** `fontSize: 28`, `fontWeight: FontWeight.w700`. Usado para títulos de pantalla únicos.
* **Títulos de Tarjetas (`titleLarge`):** `fontSize: 22`, `fontWeight: FontWeight.w600`. Usado para nombres de misiones o conceptos principales.
* **Títulos Secundarios (`titleMedium`):** `fontSize: 16`, `fontWeight: FontWeight.w600`. Usado para subencabezados dentro de tarjetas o bloques.
* **Texto de Cuerpo (`bodyLarge`):** `fontSize: 16`, `fontWeight: FontWeight.normal`, `height: 1.5`. Usado para todo el texto didáctico principal.
* **Subtextos (`bodySmall`):** `fontSize: 12`, `color: Colors.grey`. Usado para metadatos y fuentes.

---

## 3. Escala de Espaciado (AppSpacing)

Todo margen (`margin`), relleno (`padding`) y distancia (`SizedBox`) se rige por los tokens unificados de `AppSpacing`:

* **xs (`8.0`):** Distancias mínimas (ej. icono a texto, título a subtítulo).
* **sm (`12.0`):** Separaciones estrechas (ej. barras de progreso, inputs a texto).
* **md (`16.0`):** Relleno interno estándar de tarjetas y espaciado entre elementos adyacentes.
* **lg (`24.0`):** Margen general de pantallas y separaciones estructurales mayores.
* **xl (`32.0`):** Espaciado superior e inferior de layouts de bienvenida y splash.
* **xxl (`48.0`):** Reservado para espaciados extremos o de centrado vertical.

---

## 4. Componentes y Widgets Unificados

### Tarjetas (`Card`)
Configuradas globalmente en `app_theme.dart` a través de `CardThemeData`:
* **Color de fondo:** `#17171D` (Surface).
* **Bordes redondeados:** `BorderRadius.circular(16)`.
* **Borde sutil:** `BorderSide` con `OutlineVariant` al 15% de opacidad.
* **Elevación:** `0` (Material 3 plano).
* **Uso estándar:** Todo bloque de información o tarjeta expandible (`ExpansionTile`) debe estar contenido en una tarjeta limpia sin bordes redundantes (aplicando `shape: const Border()` al ExpansionTile para evitar encimar bordes).

### Botones
* **Primarios (`FilledButton`):** Reservados para la acción principal de la pantalla (ej. "Continuar misión"). Altura unificada de `54` para evitar gigantismo, y redondeado de `BorderRadius.circular(16)`. Texto en mayúsculas tipo oración (`Confirmar importación` en lugar de `CONFIRMAR IMPORTACIÓN`).
* **Secundarios (`OutlinedButton`):** Acciones alternativas o de copiar. Radio de borde unificado de `12`.
* **Botones de Grid (`_Access`):** Tarjetas interactivas de 2 columnas con bordes redondeados (`16`), iconos de acento primario y texto seminegrita para una mejor respuesta táctil.

### Campos de Texto (`TextField` / `TextFormField`)
Configurados globalmente en `app_theme.dart` a través de `InputDecorationTheme`:
* **Bordes:** Redondeados de `12` con color sutil en estado inactivo y color primario con foco.
* **Relleno:** Fondo `#17171D` con padding interno simétrico (`horizontal: 16, vertical: 16`).

### Chips de Selección (`ChoiceChip` / `ActionChip`)
Configurados globalmente en `app_theme.dart`:
* **Bordes:** Redondeados de `12`.
* **Color activo:** `primaryContainer` con texto adaptado.

---

## 5. Iconografía Consistente

* Usar **exclusivamente** variantes outline/rounded para elementos informativos (ej. `Icons.explore_rounded`, `Icons.menu_book_outlined`, `Icons.flag_outlined`).
* Los iconos de acción (ej. `Icons.copy`, `Icons.save_alt`, `Icons.replay`) se reservan para botones o listiles donde el peso visual requiera énfasis de interacción.
