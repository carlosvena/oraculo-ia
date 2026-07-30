# Backlog priorizado

Sprint 2 no está autorizado. Esta lista no implica aprobación para implementar.

## P0 — Antes de llamar a la aplicación versión 0.1

- [x] Definir `applicationId` definitivo → `com.carlosvena.oraculoia`.
- [x] Configuración de firma release lista vía `android/key.properties` (ver `docs/RELEASE_SIGNING.md`); falta que Carlos genere la keystore localmente (paso manual, clave privada).
- [ ] Reemplazar icono y launch screen nativos de Flutter por identidad ORÁCULO IA.
- [ ] Probar el APK en al menos un teléfono Android físico.
- [ ] Agregar una prueba de widget para el recorrido completo del Sprint 1.
- [ ] Decidir y aprobar cómo persistir progreso antes de implementarlo.

## P1 — Calidad de experiencia

- [ ] Validar la Misión 001 con usuarios y revisar duración real.
- [ ] Revisar accesibilidad con lector de pantalla y escalado de texto.
- [ ] Definir comportamiento cuando el alumno abandona una misión a mitad de camino.
- [ ] Separar definitivamente contenido educativo de recursos de interfaz.
- [ ] Preguntar nivel inicial (principiante/experto) en el onboarding y usarlo para ajustar la dificultad de las preguntas desde el arranque, no solo el modo Esencial/Intensivo dentro de cada lección.

## P2 — Futuro, fuera del alcance actual

- [ ] Diseñar Misión 002 sólo después de revisar Sprint 1.
- [ ] Validar contratos del Learning Engine con decisiones pedagógicas reales.
- [ ] Diseñar pipeline editorial para `knowledge/`.
- [ ] Evaluar Firebase, sincronización e IA únicamente con aprobación explícita.

