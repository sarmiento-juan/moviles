# Solución de Problemas - Emulador Android

## ❌ Error: "Failed to launch Pixel 8"

### Solución 1: Reiniciar ADB (Android Debug Bridge)

```bash
# Detener el servidor ADB
adb kill-server

# Iniciar el servidor ADB
adb start-server

# Verificar dispositivos conectados
adb devices
```

### Solución 2: Relanzar el emulador

```bash
# Ver emuladores disponibles
flutter emulators

# Lanzar el emulador específico
flutter emulators --launch Pixel_8
```

### Solución 3: Autorizar el dispositivo

1. **Verifica en el emulador** si aparece un diálogo solicitando autorización de USB debugging
2. **Marca la casilla** "Always allow from this computer"
3. **Presiona OK**

### Solución 4: Limpiar y reconstruir

```bash
# Limpiar el proyecto
flutter clean

# Obtener dependencias
flutter pub get

# Ejecutar en el emulador
flutter run
```

### Solución 5: Cold Boot del emulador

Si el emulador sigue sin responder:

1. Abre **Android Studio**
2. Ve a **Tools > Device Manager**
3. Encuentra tu emulador (Pixel 8)
4. Haz clic en el menú de opciones (⋮)
5. Selecciona **Cold Boot Now**

## 🔍 Verificar estado del sistema

```bash
# Ver información completa del entorno
flutter doctor -v

# Ver dispositivos disponibles
flutter devices

# Ver emuladores disponibles
flutter emulators
```

## 📱 Problemas Comunes

### Problema: "Device not authorized"

**Causa:** El emulador no está autorizado para debugging USB.

**Solución:**
```bash
adb kill-server
adb start-server
adb devices
```

Luego verifica en el emulador el diálogo de autorización.

### Problema: "Emulator is offline"

**Causa:** El emulador no responde correctamente.

**Solución:**
```bash
# Matar todos los procesos del emulador
taskkill /F /IM qemu-system-x86_64.exe

# O en el Device Manager de Android Studio, hacer Cold Boot
```

### Problema: "Gradle build failed"

**Causa:** Problemas con la configuración de Gradle.

**Solución:**
```bash
cd android
.\gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Problema: "No connected devices"

**Causa:** El emulador no está en ejecución o no está conectado.

**Solución:**
1. Lanza el emulador desde Android Studio o con `flutter emulators --launch Pixel_8`
2. Espera a que inicie completamente (verás el home screen de Android)
3. Ejecuta `flutter devices` para confirmar que está conectado

## 🚀 Comandos útiles

```bash
# Ejecutar en un dispositivo específico
flutter run -d emulator-5554

# Ejecutar en modo debug con logs detallados
flutter run -v

# Ejecutar en modo release
flutter run --release

# Hot reload (durante ejecución)
# Presiona 'r' en la terminal

# Hot restart (durante ejecución)
# Presiona 'R' en la terminal

# Ver logs del dispositivo
adb logcat
```

## 💡 Tips

1. **Espera suficiente:** El emulador puede tardar 30-60 segundos en iniciar completamente
2. **Verifica la RAM:** Asegúrate de tener suficiente RAM disponible (mínimo 4GB libres)
3. **Cierra otras apps:** Cierra aplicaciones pesadas antes de lanzar el emulador
4. **Usa SSD:** Los emuladores funcionan mucho mejor en discos SSD
5. **Habilita virtualización:** Verifica que VT-x/AMD-V esté habilitado en BIOS

## 🔧 Configuración recomendada del emulador

En Android Studio > Device Manager > Edit:

- **RAM:** 2048 MB o más
- **Internal Storage:** 2048 MB o más
- **Graphics:** Hardware - GLES 2.0
- **Boot option:** Quick Boot

## 📋 Checklist antes de ejecutar

- [ ] Emulador está corriendo (puedes verlo en la pantalla)
- [ ] `flutter devices` muestra el emulador
- [ ] No aparece el mensaje "not authorized"
- [ ] `flutter doctor` no muestra errores críticos en Android
- [ ] Tienes suficiente espacio en disco (mínimo 10GB libres)
- [ ] El proyecto está limpio (`flutter clean` ejecutado)

## 🆘 Si nada funciona

1. **Reinicia tu computadora**
2. **Reinstala el emulador** desde Android Studio
3. **Actualiza Android SDK** desde Android Studio > SDK Manager
4. **Verifica que ANDROID_HOME esté configurado correctamente:**
   ```bash
   echo %ANDROID_HOME%
   # Debería mostrar: C:\Users\TuUsuario\AppData\Local\Android\Sdk
   ```

## 🎯 Ejecutar la aplicación paso a paso

1. **Abre el emulador:**
   ```bash
   flutter emulators --launch Pixel_8
   ```

2. **Espera a que inicie** (verás el home screen de Android)

3. **Verifica la conexión:**
   ```bash
   flutter devices
   ```

4. **Ejecuta la app:**
   ```bash
   flutter run
   ```

5. **Si pide seleccionar dispositivo:**
   ```bash
   flutter run -d emulator-5554
   ```

---

**Nota:** Si continúas teniendo problemas, verifica los logs detallados con `flutter run -v` y revisa los mensajes de error específicos.
