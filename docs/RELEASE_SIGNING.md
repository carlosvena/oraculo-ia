# Firma de release (KI-004)

## Firma estable para que las actualizaciones no borren el progreso

Cada compilación de GitHub Actions corre en una máquina nueva. Sin una
keystore fija, cada build queda firmado con una clave distinta, y Android
trata cada APK como una app incompatible con la anterior — te obliga a
desinstalar antes de instalar, y al desinstalar se borra todo el progreso
guardado.

Para evitar esto, subí la keystore como **GitHub Secrets** (un lugar privado
del repositorio, nadie puede verlos, ni siquiera vos una vez guardados):

1. En tu repo en github.com: **Settings → Secrets and variables → Actions →
   New repository secret**.
2. Creá un secreto llamado `KEYSTORE_BASE64` con el contenido del archivo
   `keystore-base64.txt` que te dieron (todo el texto, es uno solo, largo).
3. Creá otro secreto llamado `KEYSTORE_PASSWORD` con la contraseña que te
   dieron.
4. Guardá también el archivo `.keystore` original en un lugar seguro de tu
   compu (Google Drive privado, por ejemplo) — si lo perdés, el día de
   mañana no vas a poder volver a actualizar la app con esa firma.

Con esos dos secretos configurados, todos los builds futuros usan la misma
firma automáticamente, y las actualizaciones van a instalarse **encima** de
la app existente sin borrar nada.

## Firma local (opcional, solo si compilás en tu propia compu)

El keystore de release es una clave privada. **Nunca debe subirse al
repositorio de git** (para eso están los Secrets, arriba). Ya está agregado
a `.gitignore`: `android/key.properties` y `android/app/release.keystore`.

Si en algún momento querés compilar localmente:

```
keytool -genkey -v -keystore android/app/release.keystore -alias oraculoia -keyalg RSA -keysize 2048 -validity 10000
```

Y crear `android/key.properties`:

```
storePassword=<contraseña del keystore>
keyPassword=<contraseña del keystore>
keyAlias=oraculoia
storeFile=app/release.keystore
```

