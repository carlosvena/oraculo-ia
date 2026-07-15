# Components Catalog — ORÁCULO IA

Este documento describe los componentes visuales principales y reutilizables en la base de código.

---

## 🏗️ Layout Components

### 1. `OraculoScaffold`
- **Ubicación**: `lib/src/design_system/components/oraculo_scaffold.dart`
- **Propósito**: Define el contenedor base para todas las pantallas principales. Soporta la barra de navegación lateral, el gradiente de fondo inmersivo y el control seguro de área de visualización.

### 2. `OraculoCard`
- **Ubicación**: `lib/src/design_system/components/oraculo_card.dart`
- **Propósito**: Encapsula contenedores con bordes redondeados y sombreado adaptado al tema claro/oscuro.

---

## 🧪 Interactive Widgets

### 3. `ChoiceChip`
- **Propósito**: Utilizado a lo largo del sistema de filtrado de prompts y la selección de modelo en el simulador interactivo.

### 4. `CheckboxListTile`
- **Propósito**: Utilizado en la rúbrica del simulador y en los 210 desafíos de la edición profesional para marcar elementos completados offline.
