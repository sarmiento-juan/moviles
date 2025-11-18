# Guía de Configuración Firebase - Paso a Paso

## 🚀 Configuración Inicial

### Paso 1: Instalar Dependencias

```bash
cd moviles
flutter pub add firebase_core cloud_firestore url_launcher
```

O manualmente en `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.0
  cloud_firestore: ^4.13.0
  url_launcher: ^6.1.0
```

Luego:
```bash
flutter pub get
```

### Paso 2: Instalar Firebase CLI

```bash
# Con npm (requiere Node.js instalado)
npm install -g firebase-tools

# O descarga desde: https://firebase.google.com/docs/cli
```

### Paso 3: Configurar FlutterFire

```bash
# En la raíz del proyecto (carpeta moviles)
flutterfire configure

# Selecciona:
# - Plataforma: Android, iOS (selecciona lo que uses)
# - Proyecto: Tu proyecto Firebase
# - Generador automático: Sí
```

Esto genera `lib/firebase_options.dart` automáticamente.

---

## 📱 Configuración Android

### Opción A: Automática (Recomendado)

Si ejecutaste `flutterfire configure`, ya está done!

### Opción B: Manual

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Presiona el icono de Android
4. Ingresa el nombre del paquete: `com.example.moviles`
5. Descarga `google-services.json`
6. Coloca el archivo en: `android/app/google-services.json`

**Verificar en `android/build.gradle`:**

```gradle
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.3.15' // Agregar si falta
  }
}
```

**Verificar en `android/app/build.gradle`:**

```gradle
apply plugin: 'com.google.gms.google-services' // Agregar al inicio
```

---

## 🍎 Configuración iOS

### Opción A: Automática (Recomendado)

Si ejecutaste `flutterfire configure`, ya está done!

### Opción B: Manual

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Presiona el icono de iOS
4. Ingresa el Bundle ID: `com.example.moviles`
5. Descarga `GoogleService-Info.plist`
6. Abre `ios/Runner.xcworkspace` en Xcode
7. Arrastra `GoogleService-Info.plist` a la carpeta `Runner`
8. Selecciona la opción "Copy items if needed"

---

## 🔐 Configurar Reglas de Firestore

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Firestore Database > Reglas
4. Reemplaza todo con:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /universidades/{document=**} {
      allow read: if true;
      allow create, update, delete: if true;
    }
  }
}
```

5. Presiona "Publicar"

**Nota:** Esto es para desarrollo. Para producción, implementa autenticación.

---

## ✅ Crear Colección en Firestore

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Firestore Database
3. Presiona "+ Crear colección"
4. Nombre: `universidades`
5. Primer documento (opcional - puede estar vacía inicialmente)

---

## 🧪 Probar Conexión

Ejecuta la app:

```bash
flutter run -t lib/taller_firebase_universidades/main.dart
```

**Verificar:**
1. ¿La app carga sin errores?
2. ¿Puedes crear una universidad?
3. ¿Aparece en Firebase Console?

---

## 🐛 Solucionar Problemas Comunes

### Error: "Target of URI doesn't exist"

```bash
flutter clean
flutter pub get
flutter pub add firebase_core cloud_firestore
```

### Error: "google-services.json not found"

```bash
# Desde raíz del proyecto
flutterfire configure

# O coloca manualmente en android/app/google-services.json
```

### Error de compilación en Android

```bash
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

### Firebase no conecta

**Verificar:**
1. ¿Tiene internet el emulador?
2. ¿Las reglas de Firestore permiten lectura?
3. ¿El proyecto Firebase está activo?
4. ¿La configuración es correcta?

---

## 📚 Información Útil

### ID del Paquete Android
- Por defecto: `com.example.moviles`
- Puedes cambiar en `android/app/build.gradle`

### Bundle ID iOS
- Por defecto: `com.example.moviles`
- Puedes cambiar en `ios/Runner.xcodeproj`

### URLs Útiles
- Firebase Console: https://console.firebase.google.com
- Flutter Firebase Docs: https://firebase.flutter.dev
- Cloud Firestore Docs: https://firebase.google.com/docs/firestore

---

## ✨ Próximos Pasos

Una vez configurado:

1. Ejecuta: `flutter run -t lib/taller_firebase_universidades/main.dart`
2. Presiona el botón "+"
3. Crea una universidad
4. Verifica en Firebase Console que aparece
5. Prueba editar y eliminar

---

*Guía de configuración para Taller Firebase - Gestión de Universidades*
