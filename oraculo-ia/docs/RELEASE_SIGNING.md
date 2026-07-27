# Firma de release (KI-004)

El keystore de release es una clave privada. **Nunca debe subirse a GitHub.**
Ya está agregado a `.gitignore`: `android/key.properties` y `android/app/release.keystore`.

## 1. Generar la keystore (una sola vez, en tu máquina)

```
keytool -genkey -v -keystore android/app/release.keystore -alias oraculoia -keyalg RSA -keysize 2048 -validity 10000
```

Te va a pedir una contraseña de keystore y una de alias (guardalas en un lugar seguro,
por ejemplo un gestor de contraseñas — si las perdés, no vas a poder actualizar la app
publicada en el mismo `applicationId`).

## 2. Crear `android/key.properties` (no se sube a git)

```
storePassword=<contraseña del keystore>
keyPassword=<contraseña del alias>
keyAlias=oraculoia
storeFile=app/release.keystore
```

## 3. Compilar release firmado

```
flutter build apk --release
```

Con `key.properties` presente, `build.gradle.kts` usa la firma real automáticamente.
Sin ese archivo, sigue usando la firma debug (para no romper `flutter run --release`
mientras no exista la keystore).
