# Instalación de la Beta local

## Android

1. Copiar `Aprender IA 2.2 Beta ARM64.apk` al teléfono.
2. Abrir el archivo desde Descargas o el administrador de archivos.
3. Si Android lo solicita, autorizar temporalmente la instalación desde esa fuente.
4. Instalar y abrir **Aprender IA**.

El APK ARM64 funciona en la gran mayoría de teléfonos Android actuales. La aplicación es offline y conserva el progreso en el dispositivo. Antes de reemplazar o desinstalar la app, exportar un respaldo desde **Respaldo local**.

## Compilación reproducible

Desde PowerShell, en la raíz del proyecto:

```powershell
.\tool\build_release.ps1
```

El script obtiene dependencias, ejecuta análisis y pruebas, genera el APK ARM64 con fecha de compilación y lo copia a `releases/`.
