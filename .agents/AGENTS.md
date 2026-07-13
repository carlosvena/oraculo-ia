# REGLAS DE SEGURIDAD DEL PROYECTO ORÁCULO IA

## 1. Ámbito de Trabajo Limitado
* Trabajar **únicamente** dentro del workspace activo:
  `C:\Users\carlo\.gemini\antigravity\scratch\oraculo-ia`
* No leer, modificar, mover ni eliminar archivos fuera de esa carpeta.

## 2. Exclusiones de Acceso
Está estrictamente prohibido acceder a:
* OneDrive completo o sincronizaciones ajenas al proyecto.
* Documentos personales.
* Descargas.
* Escritorio.
* Credenciales del sistema.
* Variables de entorno sensibles.
* Claves SSH.
* Tokens de acceso.
* Correos electrónicos.
* Otros repositorios locales o remotos.

## 3. Acciones que Requieren Aprobación Explícita del Usuario
Antes de ejecutar cualquiera de las siguientes acciones, el agente **debe** detenerse y pedir aprobación explícita:
* Borrar archivos o carpetas.
* Usar comandos recursivos (de borrado o modificación profunda).
* Modificar la configuración del sistema operativo.
* Instalar software globalmente.
* Cambiar la variable de entorno `PATH`.
* Ejecutar scripts descargados de Internet.
* Sobrescribir ramas remotas.
* Realizar `git push --force` (force push).
* Ejecutar `git reset --hard`.
* Ejecutar `git clean -fd`.
* Ejecutar cualquier comando fuera del workspace activo.

## 4. Acciones Permitidas sin Aprobación Previa
El agente puede realizar libremente dentro del workspace activo:
* Leer y editar archivos del código fuente y documentación.
* Ejecutar `flutter analyze`.
* Ejecutar `flutter test` (preferiblemente con `-j 1` debido a límites de memoria).
* Ejecutar `flutter pub get`.
* Compilar un APK dentro del proyecto.
* Crear commits normales de Git.
* Hacer push no forzado a la rama asignada (`antigravity/integracion-inicial`).

## 5. Modo de Operación
* **No** utilizar modo Turbo ni autoaprobación total.
* Si una tarea requiere permisos adicionales o interactuar fuera del workspace, el agente debe detenerse y explicar detalladamente:
  1. Qué permiso necesita.
  2. Para qué.
  3. Qué archivo o carpeta afectará.
  4. Qué riesgo existe.
