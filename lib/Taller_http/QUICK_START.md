#  Quick Start - Taller HTTP Chuck Norris

Guia rapida para ejecutar el proyecto sin problemas.

## ⚡ Inicio Rapido (3 pasos)

### 1. Verificar Emulador
```bash
# Ver emuladores disponibles
flutter emulators

# Ver emuladores activos
adb devices
```

### 2. Iniciar Emulador (si no esta activo)
```bash
# Opcion A: Desde Flutter
flutter emulators --launch Pixel_8

# Opcion B: Desde Android Studio
# Abrir Android Studio > AVD Manager > Play ▶️

# Esperar 30-60 segundos para que cargue completamente
```

### 3. Ejecutar la App
```bash
# Ejecutar en el emulador
flutter run -t lib/Taller_http/main.dart -d emulator-5554

# O ejecutar sin especificar dispositivo (Flutter preguntara)
flutter run -t lib/Taller_http/main.dart
```

## 🐛 Solucion de Problemas Comunes

### Error: "Emulator didn't connect within 60 seconds"

**Causa:** El emulador tarda mas de 60 segundos en iniciar.

**Solucion 1:** Usar emulador ya iniciado
```bash
# 1. Verificar si ya esta corriendo
adb devices

# 2. Si aparece "emulator-5554", ejecutar directamente
flutter run -t lib/Taller_http/main.dart -d emulator-5554
```

**Solucion 2:** Iniciar emulador manualmente primero
```bash
# 1. Iniciar emulador
flutter emulators --launch Pixel_8

# 2. ESPERAR 60 segundos ⏱️

# 3. Verificar conexion
adb devices

# 4. Ejecutar app
flutter run -t lib/Taller_http/main.dart
```

### Error: "No devices found"

**Solucion:**
```bash
# Reiniciar ADB
adb kill-server
adb start-server

# Verificar dispositivos
adb devices

# Si el emulador no aparece, reiniciarlo
flutter emulators --launch Pixel_8
```

### Error: "device unauthorized"

**Solucion:**
```bash
# 1. En el emulador: Ir a Settings > Developer Options
# 2. Activar "USB debugging"
# 3. Reiniciar ADB
adb kill-server
adb start-server
adb devices
```

### Error: Compilacion lenta

**Primera vez:** La compilacion con Gradle puede tardar 2-5 minutos. ¡Es normal! ☕

**Acelerar compilaciones:**
```bash
# Limpiar cache si hay problemas
flutter clean
flutter pub get

# Ejecutar de nuevo
flutter run -t lib/Taller_http/main.dart
```

##  Opciones de Ejecucion

### Emulador Android (Recomendado)
```bash
flutter run -t lib/Taller_http/main.dart -d emulator-5554
```
 Mejor para probar HTTP requests  
 Simula dispositivo real  
 Incluye Play Store  

### Windows Desktop
```bash
flutter run -t lib/Taller_http/main.dart -d windows
```
 Mas rapido de compilar  
 No requiere emulador  
 No simula movil real  

### Navegador Web
```bash
flutter run -t lib/Taller_http/main.dart -d edge
# o
flutter run -t lib/Taller_http/main.dart -d chrome
```
 Muy rapido  
 DevTools en el navegador  
 Algunas APIs no disponibles  

## 🔥 Hot Reload

Una vez que la app este corriendo:

```
r  → Hot Reload (recarga cambios)
R  → Hot Restart (reinicia la app)
q  → Quit (salir)
```

##  Checklist Antes de Ejecutar

- [ ] Archivo `.env` existe en la raiz del proyecto
- [ ] `.env` contiene: `CHUCK_NORRIS_API_URL=https://api.chucknorris.io`
- [ ] Emulador esta iniciado (verifica con `adb devices`)
- [ ] Conexion a internet disponible (para consumir la API)

## 📊 Verificar que Todo Esta OK

```bash
# 1. Verificar Flutter
flutter doctor

# 2. Verificar dependencias
flutter pub get

# 3. Verificar dispositivos
flutter devices

# 4. Verificar emuladores
flutter emulators

# 5. Ejecutar
flutter run -t lib/Taller_http/main.dart
```

##  Comandos utiles

```bash
# Ver logs en tiempo real
flutter logs

# Ver errores de compilacion
flutter analyze

# Limpiar proyecto
flutter clean

# Actualizar dependencias
flutter pub get

# Ver dispositivos conectados
adb devices

# Matar servidor ADB
adb kill-server

# Iniciar servidor ADB
adb start-server

# Ver lista de emuladores
flutter emulators

# Crear nuevo emulador (si es necesario)
flutter emulators --create
```

## 🌐 Probar la API Manualmente

Si quieres probar la API antes de ejecutar la app:

**En Postman o navegador:**
```
GET https://api.chucknorris.io/jokes/random
GET https://api.chucknorris.io/jokes/categories
GET https://api.chucknorris.io/jokes/random?category=dev
GET https://api.chucknorris.io/jokes/search?query=bruce
```

## 🆘 ultima Opcion: Reset Completo

Si nada funciona:

```bash
# 1. Limpiar Flutter
flutter clean

# 2. Eliminar cache de dependencias
del pubspec.lock

# 3. Reinstalar dependencias
flutter pub get

# 4. Reiniciar ADB
adb kill-server
adb start-server

# 5. Cerrar emuladores
# (Cerrar desde Android Studio AVD Manager)

# 6. Reiniciar emulador
flutter emulators --launch Pixel_8

# 7. ESPERAR 60 segundos

# 8. Ejecutar app
flutter run -t lib/Taller_http/main.dart
```

## 💡 Tips Pro

1. **Manten el emulador corriendo:** No lo cierres entre ejecuciones
2. **Usa Hot Reload:** Presiona `r` para ver cambios sin recompilar
3. **Verifica siempre con `adb devices`** antes de ejecutar
4. **Primera compilacion es lenta:** Las siguientes seran mas rapidas
5. **Usa `-d` para especificar dispositivo:** Evita el menu de seleccion

---

**¿Problemas?** Revisa `TROUBLESHOOTING.md` en la raiz del proyecto para mas ayuda.

**¿Todo funciona?** ¡Empieza a explorar las bromas de Chuck Norris! 😎
