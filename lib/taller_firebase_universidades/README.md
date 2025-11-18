# Gestión de Universidades - Firebase

Aplicación Flutter que integra Firebase para crear, leer, actualizar y eliminar universidades (CRUD completo).

## 📋 Requerimientos Cumplidos

✅ **Conexión con Firebase** - Integración completa con Firestore
✅ **Colección universidades** - Almacenamiento en tiempo real
✅ **Operaciones CRUD** - Crear, leer, actualizar y eliminar
✅ **Listado en tiempo real** - Stream de datos sincronizados
✅ **Formulario de creación** - Con validaciones
✅ **Validación de datos** - Campos no vacíos y URL válida
✅ **UI/UX profesional** - Interfaz moderna y responsiva

---

## 🗂️ Estructura del Proyecto

```
taller_firebase_universidades/
├── models/
│   └── universidad.dart              # Modelo de datos
├── services/
│   └── universidad_service.dart       # Servicio CRUD con Firestore
├── views/
│   ├── universidades_list_view.dart   # Listado en tiempo real
│   └── universidad_form_view.dart     # Formulario crear/editar
├── widgets/
│   ├── universidad_card.dart          # Card de universidad
│   ├── loading_widget.dart            # Indicador de carga
│   ├── error_widget.dart              # Widget de error
│   └── empty_state_widget.dart        # Estado vacío
├── utils/
│   └── validators.dart                # Validadores de campos
└── main.dart                          # Punto de entrada
```

---

## 📦 Paquetes Requeridos

Agrega estos paquetes a tu `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.0
  cloud_firestore: ^4.13.0
  url_launcher: ^6.1.0
```

**Instalación:**
```bash
flutter pub add firebase_core cloud_firestore url_launcher
```

---

## 🔧 Configuración Firebase

### 1. Crear Proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto (o usa uno existente)
3. Activa Firestore Database
4. Crea la colección `universidades`

### 2. Configurar Firebase en Flutter

#### Android
1. Ve a **Project Settings** en Firebase Console
2. Descarga el archivo `google-services.json`
3. Coloca el archivo en `android/app/`
4. No necesita más configuración (flutter-fire lo maneja)

#### iOS
1. Ve a **Project Settings** en Firebase Console
2. Descarga el archivo `GoogleService-Info.plist`
3. Abre `ios/Runner.xcworkspace`
4. Arrastra el archivo a **Runner** en Xcode

#### Web (opcional)
1. Ve a **Project Settings** en Firebase Console
2. Copia la configuración de Firebase
3. Inicializa en tu HTML

### 3. Reglas de Seguridad Firestore

Ve a **Firestore > Rules** y reemplaza con:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /universidades/{document=**} {
      // Permitir lectura a todos
      allow read: if true;
      // Permitir crear, actualizar y eliminar (desarrollo)
      allow create, update, delete: if true;
    }
  }
}
```

**Nota:** Para producción, implementa autenticación adecuada.

---

## 🚀 Instalación y Ejecución

### 1. Clonar y configurar proyecto

```bash
# Navegar a la carpeta del proyecto
cd moviles

# Obtener dependencias
flutter pub get

# Ejecutar build de Gradle (Android)
cd android
./gradlew build
cd ..
```

### 2. Ejecutar aplicación

```bash
# En emulador o dispositivo
flutter run -t lib/taller_firebase_universidades/main.dart

# O simplemente
flutter run
```

---

## 📱 Funcionalidades Principales

### 1. **Listado de Universidades**
- Muestra todas las universidades en tiempo real
- Stream de Firestore sincronizado
- Pull-to-refresh (deslizar para actualizar)
- Botón flotante para crear nueva universidad

### 2. **Crear Universidad**
- Formulario con 5 campos
- Validaciones en cliente
- Guardado automático en Firestore
- Confirmación visual

### 3. **Editar Universidad**
- Formulario pre-llenado
- Actualización en tiempo real
- Validaciones iguales a crear

### 4. **Eliminar Universidad**
- Diálogo de confirmación
- Eliminación instantánea
- Feedback visual

### 5. **Características Adicionales**
- Acceso directo a página web desde card
- Copiar teléfono al portapapeles
- Estados visuales: carga, error, vacío

---

## 📊 Modelo de Datos

### Estructura en Firestore

```json
{
  "nit": "890.123.456-7",
  "nombre": "UCEVA",
  "direccion": "Cra 27A #48-144, Tuluá - Valle",
  "telefono": "+57 602 2242202",
  "pagina_web": "https://www.uceva.edu.co"
}
```

### Clase Universidad (Dart)

```dart
class Universidad {
  final String id;           // ID del documento (auto-generado)
  final String nit;          // NIT de la universidad
  final String nombre;       // Nombre completo
  final String direccion;    // Dirección
  final String telefono;     // Teléfono
  final String paginaWeb;    // URL de página web
}
```

---

## ✅ Validaciones Implementadas

| Campo | Validación |
|-------|-----------|
| **NIT** | No vacío, mínimo 8 dígitos |
| **Nombre** | No vacío, 3-100 caracteres |
| **Dirección** | No vacío, mínimo 5 caracteres |
| **Teléfono** | No vacío, mínimo 7 dígitos |
| **Página Web** | URL válida con protocolo http/https |

---

## 🔄 Flujo de la Aplicación

```
┌─────────────────────────────┐
│   Pantalla de Listado       │
│  (universidades_list_view)  │
└────────────┬────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼             ▼
  ┌────────┐   ┌───────────┐
  │ Crear  │   │  Editar   │
  │Pulsar +│   │  Pulsar   │
  │        │   │ Card      │
  └────┬───┘   └─────┬─────┘
       │             │
       └──────┬──────┘
              ▼
     ┌─────────────────────┐
     │  Formulario         │
     │ (universidad_form)  │
     └────────┬────────────┘
              │
         Validar
              │
         ┌────┴────┐
         ▼         ▼
      ✅OK       ❌Error
         │         │
         │    Mostrar error
         │    Mantener form
         │
      Guardar a
     Firestore
         │
         ▼
    Volver a Listado
```

---

## 🎨 Personalización

### Cambiar colores principales

En `main.dart`:
```dart
primarySwatch: Colors.blue,  // Cambiar a Colors.green, Colors.red, etc.
```

En widgets:
```dart
backgroundColor: Colors.blue.shade600,  // Personalizar cada widget
```

### Cambiar nombre de colección

En `universidad_service.dart`:
```dart
final String _collectionName = 'universidades';  // Cambiar nombre
```

---

## 🧪 Pruebas Manuales

### Test 1: Crear Universidad
1. Presiona botón "+"
2. Rellena campos con datos válidos
3. Presiona "Crear"
4. Verifica que aparece en listado
5. Verifica en Firebase Console

### Test 2: Validaciones
1. Intenta crear sin llenar campos
2. Ingresa URL inválida
3. Ingresa NIT con menos de 8 dígitos
4. Verifica mensajes de error

### Test 3: Editar
1. Presiona "Editar" en una card
2. Modifica datos
3. Presiona "Actualizar"
4. Verifica cambios en listado

### Test 4: Eliminar
1. Presiona "Eliminar" en una card
2. Confirma en diálogo
3. Verifica que desaparece de listado

### Test 5: Tiempo Real
1. Abre en 2 dispositivos
2. Crea/Edita en uno
3. Verifica cambios en otro instantáneamente

---

## 🐛 Solución de Problemas

### Error: "Target of URI doesn't exist: 'package:cloud_firestore'"

**Solución:**
```bash
flutter clean
flutter pub get
flutter pub add cloud_firestore firebase_core
```

### Error: "google-services.json not found"

**Solución:**
1. Descarga de Firebase Console
2. Coloca en `android/app/`
3. Ejecuta: `flutter clean && flutter pub get`

### Firebase no conecta

**Verificar:**
1. ¿Está Firebase Core inicializado?
2. ¿Tiene permisos la aplicación?
3. ¿Las reglas de Firestore permiten lectura/escritura?

### No aparecen datos

**Verificar:**
1. ¿Existe la colección `universidades`?
2. ¿Contiene documentos?
3. ¿Las reglas de seguridad permiten lectura?

---

## 📝 Notas Técnicas

- **Stream vs Future**: Se usa Stream para actualizaciones en tiempo real
- **Validación**: En cliente y base de datos
- **Error Handling**: Try-catch en servicios, UI feedback al usuario
- **State Management**: Stateful widgets con setState (puede escalarse a Provider/Bloc)
- **Arquitectura**: Separación de capas (Models, Services, Views, Widgets, Utils)

---

## 🎓 Conceptos Aprendidos

1. **Firebase Firestore** - Base de datos NoSQL en tiempo real
2. **CRUD Operations** - Create, Read, Update, Delete
3. **Streams en Flutter** - Escuchar cambios en tiempo real
4. **Validación de Formularios** - Campos requeridos y patrones
5. **Manejo de Errores** - Try-catch y UI feedback
6. **Arquitectura MVC** - Separación de responsabilidades

---

## 📞 Contacto y Soporte

Si encuentras problemas o tienes sugerencias, crea un issue o contacta al desarrollador.

---

*Documentación creada para el Taller Firebase - Gestión de Universidades*
