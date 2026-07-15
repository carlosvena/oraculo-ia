# Modules Architecture — ORÁCULO IA

ORÁCULO IA está compuesto por 13 módulos modulares autocontenidos en `lib/src/features/`:

---

## 📚 1. Core Modules

### 📖 `content`
- **Responsabilidad**: Carga y gestiona el ciclo de vida de los datos offline en el motor (`KnowledgeEngine`).

### 🧭 `knowledge_map`
- **Responsabilidad**: Construcción y recorrido dinámico del grafo del conocimiento no lineal (`LearningEngine`).

---

## 🎯 2. Learning Modules

### 🎓 `academy`
- **Responsabilidad**: Navegación y renderizado del catálogo de cursos, misiones e itinerarios formativos.

### 🧪 `prompt_lab`
- **Responsabilidad**: Entorno de experimentación práctica de prompts con retroalimentación y explicaciones editoriales.

### 🔄 `review`
- **Responsabilidad**: Motor de repetición espaciada y repasos dinámicos.

---

## 💼 3. Professional Modules

### 👔 `professional`
- **Responsabilidad**: Gestión del "Modo Oficina", Casos Reales, Simuladores, Desafíos por dificultad, Plantillas y el Centro de Recursos offline.
