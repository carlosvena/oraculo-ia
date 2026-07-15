# Sistema de Diseño — ORÁCULO IA Enterprise Foundation

Este documento centraliza los tokens y reglas de diseño visual de la plataforma ORÁCULO IA.

---

## 🎨 1. Paleta de Colores (Material 3)

La aplicación sigue el esquema de colores dinámicos de Material 3 con variaciones para el aprendizaje inmersivo:
- **Primary**: `#2196F3` (Azul de aprendizaje base).
- **Secondary**: `#00BCD4` (Cyan).
- **Dark Accent (Modo Oficina)**: `#1E3C72` (Azul oscuro profesional).
- **Success**: `#4CAF50` (Verde para respuestas correctas).
- **Warning**: `#FF9800` (Naranja para reintentos o dificultad media).
- **Error / Danger**: `#F44336` (Rojo para errores del Mentor o fallas).

---

## 📐 2. Espaciados y Layout (`AppSpacing`)

El espaciado se rige por una escala de base 8 centralizada en `lib/src/design_system/foundations/app_spacing.dart`:
- **xs**: `4.0`
- **sm**: `8.0`
- **md**: `16.0`
- **lg**: `24.0`
- **xl**: `32.0`
- **xxl**: `48.0`

---

## ✍️ 3. Tipografía

Utiliza fuentes del sistema optimizadas:
- **Títulos**: Outfit / Roboto con `FontWeight.bold`.
- **Cuerpo**: Inter / Roboto con `height: 1.4` para mejorar la legibilidad didáctica.
- **Monospace**: `monospace` para bloques de código y metaprompts.

---

## 🍱 4. Componentes Reutilizables

- **`OraculoScaffold`**: Envoltura principal que maneja fondos, padding de sistema y temas.
- **`OraculoCard`**: Tarjetas de contenido con elevación sutil y bordes redondeados a `12.0`.
- **`ChoiceChip`**: Chips de selección para filtrar categorías o elegir modelos.
- **`ExpansionTile`**: Bloques desplegables para guías, plantillas y prompts detallados.
