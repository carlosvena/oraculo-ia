# Problemas conocidos

## KI-001 — Progreso no persistente

**Impacto:** al cerrar completamente la aplicación se reinician XP y finalización.

**Motivo:** Sprint 1 fue aprobado como experiencia simulada.

**Posibles soluciones:** almacenamiento local simple o repositorio persistente. Debe
decidirse antes de implementar.

## KI-002 — Launch screen nativo genérico

**Impacto:** en un arranque frío aparece el logo blanco de Flutter antes de la UI.

**Posible solución:** crear recursos Android de Splash e icono para ORÁCULO IA.

## KI-003 — Identificador de paquete provisional

**Impacto:** el APK usa `com.example.oraculo_ia`, no apto para publicación.

**Posible solución:** definir el identificador definitivo antes de versión 0.1.

## KI-004 — Firma de desarrollo

**Impacto:** el APK release usa la clave debug del template. Es instalable para
revisión, pero no publicable.

**Posible solución:** keystore privado fuera del repositorio y configuración segura.

## KI-005 — Build directo dentro de OneDrive

**Impacto:** Flutter puede fallar al borrar `build/` o generar localizaciones.

**Solución actual:** compilar desde una copia temporal y copiar artefactos finales.

**Alternativas:** mover el repositorio fuera de OneDrive o revisar sus ACL con el
usuario. No modificar permisos automáticamente.

## KI-006 — Memoria limitada durante APK universal

**Impacto:** un build limpio puede tardar varios minutos; builds AOT simultáneos
pueden agotar memoria.

**Solución actual:** límites en `android/gradle.properties` y un worker.

**Alternativas:** ampliar archivo de paginación o compilar una ABI por vez.

