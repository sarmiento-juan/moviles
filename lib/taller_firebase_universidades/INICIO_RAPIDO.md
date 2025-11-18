# 🎓 Taller Firebase - Gestión de Universidades

Aplicación **Flutter completa** que integra **Firebase Firestore** para gestionar una colección de universidades colombianas con operaciones **CRUD** en tiempo real.

---

## ✨ Características Principales

### 📋 Funcionalidad CRUD
- ✅ **Crear** universidades mediante formulario
- ✅ **Leer** datos en tiempo real con Stream
- ✅ **Actualizar** información existente
- ✅ **Eliminar** registros con confirmación

### 🔄 Tiempo Real
- ✅ Stream sincronizado con Firestore
- ✅ Cambios instantáneos entre dispositivos
- ✅ Pull-to-refresh para actualización manual

### ✅ Validaciones
- ✅ NIT: Mínimo 8 dígitos
- ✅ Nombre: 3-100 caracteres
- ✅ Dirección: Mínimo 5 caracteres
- ✅ Teléfono: Mínimo 7 dígitos
- ✅ Página Web: URL válida con protocolo

### 🎨 Interfaz Profesional
- ✅ Material Design 3
- ✅ Cards con gradientes
- ✅ Estados visuales (carga, error, vacío)
- ✅ Tema personalizado
- ✅ Navegación fluida

---

## 📱 Pantallas

### 1. Listado de Universidades
```
┌─────────────────────────────────┐
│ Universidades                   │
│ ────────────────────────────────│
│ ┌─────────────────────────────┐ │
│ │ 🏫 UCEVA                    │ │
│ │ NIT: 890.123.456-7          │ │
│ │ ──────────────────────────  │ │
│ │ 📍 Cra 27A #48-144, Tuluá   │ │
│ │ 📞 +57 602 2242202         │ │
│ │ 🌐 https://www.uceva.edu.co│ │
│ │      [Editar]  [Eliminar]   │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ 🏫 Universidad Nacional     │ │
│ │ NIT: 899.123.456-1          │ │
│ │ ... (más universidades)     │ │
│ └─────────────────────────────┘ │
│                                 │
│                   [➕ Nueva]    │
└─────────────────────────────────┘
```

### 2. Formulario Nueva/Editar
```
┌─────────────────────────────────┐
│ Nueva Universidad               │
│ ────────────────────────────────│
│                                 │
│ [Completa los datos...]         │
│                                 │
│ NIT: ___________________       │
│                                 │
│ Nombre: ______________________ │
│                                 │
│ Dirección: ____________________ │
│                                 │
│ Teléfono: _____________________ │
│                                 │
│ Página Web: __________________  │
│                                 │
│ [    CREAR    ]  [CANCELAR]    │
│                                 │
└─────────────────────────────────┘
```

---

## 🗂️ Estructura del Proyecto

```
taller_firebase_universidades/
│
├── 📄 main.dart                          # Punto de entrada
├── 📄 README.md                          # Esta documentación
├── 📄 CONFIGURACION.md                   # Guía de setup Firebase
├── 📄 EJEMPLOS.md                        # Ejemplos de código
├── 📄 ARQUITECTURA.md                    # Diagramas y flujos
│
├── 📁 models/
│   └── 📄 universidad.dart               # Modelo de datos
│
├── 📁 services/
│   └── 📄 universidad_service.dart       # Lógica CRUD
│
├── 📁 views/
│   ├── 📄 universidades_list_view.dart   # Pantalla listado
│   └── 📄 universidad_form_view.dart     # Pantalla formulario
│
├── 📁 widgets/
│   ├── 📄 universidad_card.dart          # Card de información
│   ├── 📄 loading_widget.dart            # Indicador de carga
│   ├── 📄 error_widget.dart              # Mensaje de error
│   └── 📄 empty_state_widget.dart        # Estado vacío
│
├── 📁 utils/
│   └── 📄 validators.dart                # Validadores
│
└── 📁 firebase/
    └── 📄 firebase_init.dart             # Inicialización Firebase
```

---

## 📦 Dependencias Requeridas

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.0          # Firebase core
  cloud_firestore: ^4.13.0        # Firestore database
  url_launcher: ^6.1.0            # Abrir URLs
```

**Instalar:**
```bash
flutter pub add firebase_core cloud_firestore url_launcher
```

---

## 🚀 Inicio Rápido

### 1. Configurar Firebase
```bash
# Instala Firebase CLI
npm install -g firebase-tools

# Configura el proyecto
flutterfire configure
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Ejecutar
```bash
flutter run -t lib/taller_firebase_universidades/main.dart
```

---

## 📚 Documentación

| Archivo | Contenido |
|---------|----------|
| **README.md** | Descripción general y primeros pasos |
| **CONFIGURACION.md** | Guía paso a paso para setup Firebase |
| **ARQUITECTURA.md** | Diagramas, flujos y estructura visual |
| **EJEMPLOS.md** | Ejemplos prácticos de código |

---

## 🔑 Conceptos Clave

### 1. **Firestore**
- Base de datos NoSQL en la nube
- Documentos organizados en colecciones
- Sincronización en tiempo real con Stream

### 2. **CRUD Operations**
- **Create**: Crear nuevos documentos
- **Read**: Leer documentos (Future/Stream)
- **Update**: Actualizar campos
- **Delete**: Eliminar documentos

### 3. **Stream**
- Escucha cambios en tiempo real
- StreamBuilder reconstruye la UI automáticamente
- Ideal para datos que cambian frecuentemente

### 4. **Validación**
- En cliente: Antes de enviar a Firestore
- Feedback visual en el formulario
- Previene datos inválidos

### 5. **Arquitectura MVC**
- **Models**: Estructuras de datos
- **Views**: Pantallas de la app
- **Controllers/Services**: Lógica de negocio

---

## 📊 Base de Datos - Estructura

### Colección: `universidades`

```json
universidades
├── documento_1
│   ├── nit: string
│   ├── nombre: string
│   ├── direccion: string
│   ├── telefono: string
│   └── pagina_web: string (URL)
│
├── documento_2
│   ├── nit: string
│   ├── nombre: string
│   ├── direccion: string
│   ├── telefono: string
│   └── pagina_web: string (URL)
│
└── ...
```

### Ejemplo de Documento

```json
{
  "nit": "890.123.456-7",
  "nombre": "UCEVA",
  "direccion": "Cra 27A #48-144, Tuluá - Valle",
  "telefono": "+57 602 2242202",
  "pagina_web": "https://www.uceva.edu.co"
}
```

---

## 🎯 Funcionalidades Avanzadas

### Métodos del Servicio

```dart
// Obtener en tiempo real
Stream<List<Universidad>> obtenerUniversidadesStream()

// Obtener una vez
Future<List<Universidad>> obtenerUniversidades()

// Buscar por ID
Future<Universidad?> obtenerUniversidadPorId(String id)

// Crear
Future<String> crearUniversidad(Universidad universidad)

// Actualizar
Future<void> actualizarUniversidad(String id, Universidad universidad)

// Eliminar
Future<void> eliminarUniversidad(String id)

// Validaciones
Future<bool> existeNit(String nit)
Future<List<Universidad>> buscarPorNombre(String nombre)
Future<int> obtenerTotalUniversidades()
```

---

## ✅ Validaciones Implementadas

| Campo | Regla |
|-------|-------|
| NIT | No vacío, mínimo 8 dígitos |
| Nombre | No vacío, 3-100 caracteres |
| Dirección | No vacío, mínimo 5 caracteres |
| Teléfono | No vacío, mínimo 7 dígitos |
| Página Web | URL válida con http/https |

---

## 🐛 Solución de Problemas

### Firebase no conecta
```
1. Verifica que tengas internet
2. Revisa las reglas de Firestore
3. Confirma que la colección existe
```

### Validación falla
```
1. Asegúrate que los datos sean válidos
2. Verifica el formato de NIT y teléfono
3. Confirma que la URL tenga protocolo (https://)
```

### Stream no actualiza
```
1. Verifica que hayas presionado guardar
2. Comprueba en Firebase Console
3. Recarga la app si es necesario
```

---

## 🎓 Conceptos Aprendidos

- ✅ Integración Firebase en Flutter
- ✅ Operaciones CRUD con Firestore
- ✅ Streams y tiempo real
- ✅ Formularios con validación
- ✅ Manejo de errores
- ✅ Arquitectura MVC
- ✅ Material Design 3
- ✅ Navegación entre pantallas

---

## 📝 Requerimientos Cumplidos

| Requerimiento | Estado | Archivo |
|---------------|--------|---------|
| Conexión Firebase | ✅ | main.dart |
| Colección universidades | ✅ | CONFIGURACION.md |
| CRUD completo | ✅ | universidad_service.dart |
| Formulario | ✅ | universidad_form_view.dart |
| Listado tiempo real | ✅ | universidades_list_view.dart |
| Validación campos | ✅ | validators.dart |
| Vista de evidencia | ✅ | universidad_card.dart |

---

## 🔗 Enlaces Útiles

- [Firebase Console](https://console.firebase.google.com)
- [Flutter Firebase Docs](https://firebase.flutter.dev)
- [Cloud Firestore Docs](https://firebase.google.com/docs/firestore)
- [Dart Documentation](https://dart.dev/guides)

---

## 📞 Soporte

Si tienes dudas o problemas:
1. Revisa la carpeta de documentación
2. Consulta EJEMPLOS.md para código de referencia
3. Verifica CONFIGURACION.md para setup

---

## 📄 Licencia

Este proyecto es educativo para el Taller Firebase.

---

**Creado para:** Taller Firebase - Gestión de Universidades  
**Lenguaje:** Dart + Flutter 3.0+  
**Base de Datos:** Google Firebase Firestore  
**Fecha:** 2025

*¡Éxito en tu desarrollo!* 🚀
