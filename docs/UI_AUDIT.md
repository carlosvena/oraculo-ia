# AUDITORÍA VISUAL Y DE UI — ORÁCULO IA

Este documento detalla los hallazgos de la auditoría visual realizada sobre las pantallas y componentes de **ORÁCULO IA** (Fase 1 de la Operación Pulido).

---

## 1. Márgenes e Espaciados Inconsistentes

* **Espaciados ad-hoc (`SizedBox`):** Se detectó el uso recurrente de valores arbitrarios de espaciado vertical/horizontal que no forman parte de la escala de `AppSpacing` (por ejemplo, `height: 20`, `height: 28`, `height: 10` y `height: 12`). Estos se encuentran en:
  - `welcome_screen.dart` (alturas de 28 y 20).
  - `current_mission_screen.dart` (alturas de 8, 12 y 16).
  - `beta_screens.dart` (alturas de 8, 10, 12, 16 y 20).
  - `assessment_screen.dart` (alturas de 8, 12 y 16).
  - `review_screen.dart` (alturas de 8 y 16).
* **Márgenes de pantalla rígidos:**
  - `welcome_screen.dart` utiliza un padding fijo inline `EdgeInsets.all(24)` en lugar de adaptarse al tamaño de pantalla del dispositivo o usar los tokens de `AppSpacing`.
* **Paddings en tarjetas declarados inline:**
  - Las tarjetas en `current_mission_screen.dart`, `progress_screen.dart`, `beta_screens.dart`, `assessment_screen.dart` y `review_screen.dart` configuran paddings fijos de `12` o `16` de manera inline, en lugar de centralizar esta decoración en el `CardTheme` global o usar `AppSpacing.md`.

---

## 2. Tipografías y Tamaños de Texto sin Criterio Unificado

* **Inconsistencia jerárquica de títulos:**
  - Los encabezados de sección en varias pantallas usan `headlineMedium` (ej. en `current_mission_screen.dart`, `progress_screen.dart`, `beta_screens.dart`), pero en otras como `knowledge_map_screen.dart` o `prompt_lab_screen.dart` se combinan de manera desordenada con tamaños de tipo alternativos.
* **Pesos de fuente forzados inline:**
  - Varias pantallas definen estilos de texto inline con `fontWeight: FontWeight.w700` o `w600` (como en `lesson_block.dart`), sobreescribiendo el tema de Material 3 y dificultando la mantenibilidad tipográfica.

---

## 3. Botones, Inputs y Alineaciones Desbalanceadas

* **Capitalización de textos inconsistente:**
  - Los botones de acción oscilan de manera aleatoria entre el uso de mayúsculas sostenidas (`EXPORTAR PDF`, `VALIDAR Y VER VISTA PREVIA`, `CONFIRMAR IMPORTACIÓN`, `LEER MÁS`) y la capitalización de oración común de Material Design (ej. `CONTINUAR MI MISIÓN`, `Ver explicación`).
* **Bordes y campos de texto sin unificar:**
  - Los campos `TextField` y `TextFormField` en `prompt_lab_screen.dart`, `assessment_screen.dart`, `review_screen.dart` y `beta_screens.dart` usan bordes `OutlineInputBorder()` directos. Estos no unifican el radio de curvatura (`borderRadius`) de sus esquinas con el de las tarjetas (`Card`), que varía entre 12, 16 y 24, restándole consistencia al diseño.
* **Estiramiento forzado de botones:**
  - El botón primario configurado en el tema global posee un tamaño mínimo forzado de alto de `64` (`minimumSize: const Size.fromHeight(64)`), lo que causa que todos los `FilledButton` se rendericen gigantes, restando equilibrio frente a los `OutlinedButton` que son más compactos.

---

## 4. Colores y Contraste Inconsistentes

* **Uso de colores primarios e inline crudos:**
  - En `knowledge_map_screen.dart`, los estados de los nodos usan colores predeterminados (`Colors.grey`, `Colors.amber`, `Colors.blue`, `Colors.orange`) en lugar de mapearse a colores semánticos dentro del `colorScheme` de Material 3 (`outline`, `tertiary`, `primary`, `error`).
  - En `lesson_block.dart`, la opacidad de los fondos se calcula inline usando `withValues(alpha: ...)` directamente sobre colores primarios, lo cual puede generar problemas de lectura y contraste sobre fondos oscuros no controlados.

---

## 5. Tarjetas y Estructura Cluttered (Sobrecargada)

* **Menu "Explorar" desorganizado:**
  - En `current_mission_screen.dart`, la sección de exploración utiliza un `Wrap` de `TextButton.icon`. Debido a que cada etiqueta tiene un largo diferente, los botones se distribuyen de forma desordenada y asimétrica, dejando espacios vacíos y dificultando el escaneo visual rápido en móviles.
* **ExpansionTiles anidados dentro de Tarjetas:**
  - En `review_screen.dart` y `career_paths.dart`, la combinación de `Card` -> `ExpansionTile` -> `ListTile` o inputs genera una redundancia estructural. Los bordes se enciman y se desperdicia espacio en pantalla por acumulación de paddings internos.
  - En particular, en `review_screen.dart` se anida un `ExpansionTile` para "VER EXPLICACIÓN" dentro de otro `ExpansionTile` de concepto, lo que resulta confuso para el flujo de interacción de recuperación activa.

---

## 6. Iconografía Desigual

* **Mezcla de estilos Outline y Solid:**
  - Coexisten iconos con bordes lineales (`Icons.flag_outlined`, `Icons.menu_book_outlined`, `Icons.auto_awesome_rounded`) junto a iconos de relleno sólido (`Icons.replay`, `Icons.copy`, `Icons.save_alt`) sin una justificación de estado o jerarquía.

---

## 7. Mensajes de Estado y Experiencia de Usuario

* **Feedback de texto plano:**
  - Las pantallas de importación/exportación (`BackupScreen`, `ManualExportScreen`) imprimen los mensajes de confirmación de éxito y los errores directamente como widgets de texto estáticos al pie del layout (`Text(message)`). Esto carece de animación, énfasis visual o respuesta interactiva.
* **Loaders e Indicadores inline:**
  - El indicador de carga en `WelcomeScreen` utiliza un tamaño de 24 inline con un `CircularProgressIndicator` de `strokeWidth: 2`, mientras que otros módulos usan el indicador estándar sin límites, generando saltos de tamaño inesperados.
