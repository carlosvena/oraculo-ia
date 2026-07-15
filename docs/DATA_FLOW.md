# Data Flow — ORÁCULO IA

Este documento describe la secuencia de flujo de datos offline de la aplicación.

---

## ⚡ 1. Inicialización y Carga de Datos

```
[editorial_manifest_v1.json]
       │ (Leído al iniciar)
       ▼
[KnowledgeEngine] ──► Pre-carga asíncrona de JSONs específicos
       │
       ▼
[UI / Presentation] (Consumo reactivo mediante Providers)
```

---

## 📊 2. Persistencia del Progreso

```
[Interacción del Usuario] (e.g. Resolver Desafío, Copiar Prompt)
       │
       ▼
[Notifier / StateNotifier] (e.g. ProfessionalStateNotifier)
       │
       ├─────────────────────────────────┐
       ▼                                 ▼
[Actualiza Estado Reactivo]        [Escribe en SharedPreferences]
       │                                 │ (Persiste offline)
       ▼                                 ▼
[UI Rebuilds]                      [Recuperable tras Reiniciar]
```
