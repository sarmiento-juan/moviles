# 🎯 Plan de Primer Día - Gestión de Universidades Firebase

Guía paso a paso para tu primer día trabajando con este proyecto.

---

## ⏱️ Horario Recomendado

```
9:00 - 9:15  → Lectura inicial (LEEME_PRIMERO.md)
9:15 - 9:20  → Instalación de dependencias
9:20 - 10:00 → Configuración de Firebase
10:00 - 10:30 → Ejecutar y probar la app
10:30 - 11:00 → Explorar el código (main.dart)
11:00 - 12:00 → Leer ARQUITECTURA.md
12:00 - 13:00 → ALMUERZO
13:00 - 14:00 → Leer README.md
14:00 - 15:00 → Revisar EJEMPLOS.md
15:00 - 15:30 → Personalizar la app
15:30 - 16:00 → Crear 5 universidades
16:00 - 16:30 → Documentar lo aprendido
16:30 - 17:00 → Planificar próximas mejoras
```

---

## 🎯 Objetivos del Día

### Mañana (Configuración)
- [ ] Entender qué es el proyecto
- [ ] Instalar dependencias
- [ ] Configurar Firebase
- [ ] Ejecutar la aplicación

### Tarde (Aprendizaje)
- [ ] Entender la arquitectura
- [ ] Explorar el código principal
- [ ] Ver ejemplos de uso
- [ ] Personalizar la app

### Noche (Consolidación)
- [ ] Crear universidades de prueba
- [ ] Verificar en Firebase Console
- [ ] Documentar lo aprendido
- [ ] Planificar mejoras

---

## 📋 Tareas Paso a Paso

### 9:00 - 9:15 | Lectura Inicial

```bash
1. Abre VS Code
2. Ve a: lib/taller_firebase_universidades/
3. Lee: 00_LEEME_PRIMERO.md (5 minutos)
```

**Objetivo:** Entender qué voy a crear

---

### 9:15 - 9:20 | Instalar Dependencias

```bash
# En la terminal, en la raíz del proyecto (carpeta moviles)
cd c:\Users\Sarmiento\Desktop\Flutter-Uceva\moviles

# Instala
flutter pub add firebase_core cloud_firestore url_launcher

# Verifica
flutter pub get
```

**Objetivo:** Tener todas las librerías necesarias

---

### 9:20 - 10:00 | Configurar Firebase

```bash
# Instala Firebase CLI (si no lo tienes)
npm install -g firebase-tools

# Configura el proyecto
flutterfire configure

# Sigue las instrucciones:
# 1. Selecciona tu proyecto Firebase
# 2. Selecciona plataformas (Android, iOS)
# 3. Espera a que termine
```

**Objetivo:** Conectar la app con Firebase

**Si tienes dudas:** Lee `CONFIGURACION.md`

---

### 10:00 - 10:30 | Ejecutar la App

```bash
# En la terminal
flutter run -t lib/taller_firebase_universidades/main.dart

# Espera a que se compile
# Debería abrir en el emulador
```

**Checklist:**
- [ ] La app abre sin errores
- [ ] Veo una pantalla azul
- [ ] Hay un botón "+" en la esquina
- [ ] Dice "Sin Universidades"

**Si hay problemas:**
- Verifica que Firebase está configurado
- Revisa que tienes internet en el emulador
- Consulta `CONFIGURACION.md`

---

### 10:30 - 11:00 | Explorar main.dart

```dart
// En VS Code, abre: main.dart

// Ve qué hace:
1. MaterialApp - Configuración de la app
2. Tema (colors, fonts)
3. Home: UniversidadesListView
4. Routes: Rutas de navegación
```

**Preguntas a responder:**
- ¿Cuál es la pantalla inicial?
- ¿Cuántas rutas hay?
- ¿Cuál es el tema de color?

**Tiempo:** 15-20 minutos

---

### 11:00 - 12:00 | Leer ARQUITECTURA.md

```bash
# Abre el archivo
lib/taller_firebase_universidades/ARQUITECTURA.md

# Lee estas secciones:
1. Diagrama de la aplicación (5 min)
2. Flujo de pantallas (5 min)
3. Estructura de datos (5 min)
4. Diagrama de componentes (5 min)
5. Estadísticas del proyecto (5 min)
```

**Objetivo:** Entender cómo se organiza todo

**Notas importantes:**
- Anota el flujo de navegación
- Entiende las capas (Models, Services, Views, Widgets)
- Visualiza cómo se ve en Firestore

---

### 12:00 - 13:00 | ALMUERZO 🍴

¡Descansa!

---

### 13:00 - 14:00 | Leer README.md

```bash
# Abre el archivo
lib/taller_firebase_universidades/README.md

# Lee estas secciones:
1. Descripción general (5 min)
2. Requerimientos cumplidos (5 min)
3. Funcionalidades principales (10 min)
4. Modelo de datos (5 min)
5. Validaciones (5 min)
6. Flujo de la aplicación (10 min)
7. Solución de problemas (5 min)
```

**Objetivo:** Conocer todas las funcionalidades

**Ejercicio:**
- [ ] Apunta 5 funcionalidades interesantes
- [ ] Escribe qué validaciones existen
- [ ] Entiende el modelo de datos

---

### 14:00 - 15:00 | Revisar EJEMPLOS.md

```bash
# Abre el archivo
lib/taller_firebase_universidades/EJEMPLOS.md

# Lee estos ejemplos:
1. Crear una universidad (5 min)
2. Obtener datos (5 min)
3. Usar Stream (5 min)
4. Validar campos (5 min)
5. CRUD completo (10 min)
6. Manejo de errores (10 min)
7. Formulario completo (10 min)
```

**Objetivo:** Ver código real funcionando

**Ejercicio:**
- [ ] Copia un ejemplo en un archivo de prueba
- [ ] Intenta entender cada línea
- [ ] Pregunta en chat si no entiendes

---

### 15:00 - 15:30 | Personalizar la App

```bash
# Abre: main.dart

# Cambios fáciles:
1. Cambiar color principal
   primarySwatch: Colors.blue  → Colors.green

2. Cambiar título de la app
   'Gestión de Universidades' → 'Mis Universidades'

3. Cambiar nombre de la app
   title: 'Universidades' → title: 'Mi App'
```

**Comando:**
```bash
# Recompila con los cambios
flutter run -t lib/taller_firebase_universidades/main.dart
```

**Ejercicio:**
- [ ] Cambia el color a verde
- [ ] Cambia el título
- [ ] Verifica los cambios en la app

---

### 15:30 - 16:00 | Crear Universidades

En la app, crea 5 universidades de prueba:

```
1️⃣ UCEVA
   NIT: 890.123.456-7
   Dirección: Cra 27A #48-144, Tuluá - Valle
   Teléfono: +57 602 2242202
   Web: https://www.uceva.edu.co

2️⃣ Universidad Nacional
   NIT: 899.123.456-1
   Dirección: Cra 45 #26-85, Bogotá
   Teléfono: +57 1 3165000
   Web: https://www.unal.edu.co

3️⃣ Pontificia Universidad Javeriana
   NIT: 891.222.333-4
   Dirección: Cra 7 #40-62, Bogotá
   Teléfono: +57 1 3208300
   Web: https://www.javeriana.edu.co

4️⃣ Universidad de los Andes
   NIT: 890.333.444-5
   Dirección: Cra 1 #18A-12, Bogotá
   Teléfono: +57 1 3394949
   Web: https://www.uniandes.edu.co

5️⃣ Universidad del Cauca
   NIT: 891.555.666-7
   Dirección: Calle 5 #4-85, Popayán
   Teléfono: +57 2 8209800
   Web: https://www.unicauca.edu.co
```

**Checklist:**
- [ ] Se crean sin errores
- [ ] Aparecen en la lista
- [ ] Se ven en Firebase Console

---

### 16:00 - 16:30 | Verificar en Firebase

```bash
1. Ve a: https://console.firebase.google.com
2. Abre tu proyecto
3. Ve a: Firestore Database
4. Verifica la colección "universidades"
5. Cuenta cuántos documentos hay (deberían ser 5)
6. Expande un documento para ver los campos
```

**Checklist:**
- [ ] Veo la colección "universidades"
- [ ] Hay 5 documentos
- [ ] Los campos son: nit, nombre, direccion, telefono, pagina_web
- [ ] Los datos son los que creé

---

### 16:30 - 17:00 | Documentar y Planificar

```markdown
## Lo que aprendí hoy

### Conceptos
- [ ] Qué es Firestore
- [ ] Qué es CRUD
- [ ] Qué es un Stream
- [ ] Arquitectura MVC

### Funcionalidades
- [ ] Cómo crear una universidad
- [ ] Cómo editar una universidad
- [ ] Cómo eliminar una universidad
- [ ] Cómo funcionan las validaciones

### Código
- [ ] Dónde está el modelo Universidad
- [ ] Dónde están las validaciones
- [ ] Dónde está el formulario
- [ ] Dónde está el listado

### Dudas
- [ ] ...

## Para mañana

### Tareas
- [ ] Leer REFERENCIA_RAPIDA.md
- [ ] Revisar university_service.dart
- [ ] Revisar universidades_list_view.dart
- [ ] Revisar universidad_form_view.dart

### Mejoras a agregar
- [ ] ...
```

---

## 📊 Resumen del Día

### ✅ Completado
- Leíste 5 documentos
- Instalaste dependencias
- Configuraste Firebase
- Ejecutaste la app
- Creaste 5 universidades
- Exploraste el código

### 📚 Aprendiste
- Arquitectura del proyecto
- Funcionalidades CRUD
- Validaciones
- Streams en tiempo real
- Material Design 3

### 🎯 Próximos Días
- Agregar búsqueda
- Agregar filtros
- Agregar caché offline
- Agregar autenticación

---

## 🆘 Si Algo Sale Mal

### "No puede conectar a Firebase"
→ Revisa `CONFIGURACION.md`

### "No puedo instalar dependencias"
```bash
flutter clean
flutter pub get
flutter pub add firebase_core cloud_firestore url_launcher
```

### "La app no se abre"
→ Verifica que el emulador está corriendo
→ Prueba con: `flutter run`

### "No puedo crear universidades"
→ Verifica que Firebase está configurado
→ Comprueba conexión a internet
→ Revisa las reglas de Firestore

### "Quiero entender el código"
→ Lee `EJEMPLOS.md` → Abre los archivos `.dart` → Lee comentarios

---

## 📞 Contacto y Ayuda

### Documentación disponible:
- `00_LEEME_PRIMERO.md` - Índice
- `INICIO_RAPIDO.md` - 5 min
- `README.md` - Completa
- `CONFIGURACION.md` - Firebase
- `ARQUITECTURA.md` - Diseño
- `EJEMPLOS.md` - Código
- `REFERENCIA_RAPIDA.md` - Quick ref

### Carpetas con código:
- `models/` - Estructuras de datos
- `services/` - Lógica CRUD
- `views/` - Pantallas
- `widgets/` - Componentes
- `utils/` - Validadores

---

## 🎉 ¡Felicidades!

Completaste tu primer día con Firebase en Flutter.

### Ahora sabes:
✅ Cómo instalar y configurar Firebase  
✅ Cómo crear, editar, eliminar datos  
✅ Cómo usar Streams para datos en tiempo real  
✅ Cómo validar formularios  
✅ Cómo se estructura un proyecto Flutter profesional  

### Mañana puedes:
✅ Agregar nuevas funcionalidades  
✅ Personalizar más la app  
✅ Crear tests  
✅ Preparar para producción  

---

**¡Excelente trabajo! 🚀**

Hoy sentaste las bases para ser un excelente desarrollador Flutter.

*Sigue adelante, ¡el resto es aún mejor!*
