# 📑 Referencia Rápida - Gestión de Universidades Firebase

Guía de referencia rápida para desarrollar con esta aplicación.

---

## 🚀 Primeros Pasos (5 minutos)

```bash
# 1. Ir a la carpeta del proyecto
cd moviles

# 2. Instalar dependencias
flutter pub add firebase_core cloud_firestore url_launcher

# 3. Configurar Firebase
flutterfire configure

# 4. Ejecutar la app
flutter run -t lib/taller_firebase_universidades/main.dart
```

---

## 📁 Archivos Clave

### main.dart
```dart
// Punto de entrada
// - MaterialApp configurado
// - Routes definidas
// - Tema global
```

### models/universidad.dart
```dart
// Clase Universidad
// - fromFirestore(): JSON → Objeto
// - toFirestore(): Objeto → JSON
// - copyWith(): Crear copias modificadas
```

### services/universidad_service.dart
```dart
// CRUD completo
// - obtenerUniversidadesStream(): Stream<List>
// - crearUniversidad(Universidad): Future<String>
// - actualizarUniversidad(id, Universidad): Future<void>
// - eliminarUniversidad(id): Future<void>
```

### views/universidades_list_view.dart
```dart
// Pantalla de listado
// - StreamBuilder para tiempo real
// - FloatingActionButton para crear
// - Card para cada universidad
```

### views/universidad_form_view.dart
```dart
// Pantalla de formulario
// - TextFormField x5
// - Validadores
// - Botones Guardar/Cancelar
```

---

## ⚙️ Configuración Firebase

### 1. Firebase Console
```
1. console.firebase.google.com
2. Crear proyecto
3. Crear app (Android/iOS)
4. Descargar configuración
```

### 2. FlutterFire
```bash
npm install -g firebase-tools
flutterfire configure
```

### 3. Firestore Reglas
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /universidades/{document=**} {
      allow read, write: if true;
    }
  }
}
```

---

## 💻 Crear Nueva Universidad (Código)

```dart
final service = UniversidadService();

final universidad = Universidad(
  id: '',
  nit: '890.123.456-7',
  nombre: 'UCEVA',
  direccion: 'Cra 27A #48-144, Tuluá - Valle',
  telefono: '+57 602 2242202',
  paginaWeb: 'https://www.uceva.edu.co',
);

final id = await service.crearUniversidad(universidad);
```

---

## 📊 Leer Datos en Tiempo Real

```dart
// Stream (recomendado para lista)
StreamBuilder<List<Universidad>>(
  stream: UniversidadService().obtenerUniversidadesStream(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final universidades = snapshot.data ?? [];
      return ListView.builder(
        itemCount: universidades.length,
        itemBuilder: (context, index) {
          return UniversidadCard(
            universidad: universidades[index],
          );
        },
      );
    }
    return const LoadingWidget();
  },
)

// Future (leer una sola vez)
final universidades = await UniversidadService()
  .obtenerUniversidades();
```

---

## ✏️ Actualizar Universidad

```dart
final service = UniversidadService();

// Obtener universidad actual
final uni = await service.obtenerUniversidadPorId('ABC123');

// Modificar
final actualizada = uni!.copyWith(
  nombre: 'UCEVA - Universidad Colombiana',
);

// Guardar cambios
await service.actualizarUniversidad(uni.id, actualizada);
```

---

## 🗑️ Eliminar Universidad

```dart
final service = UniversidadService();

// Mostrar diálogo de confirmación
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Eliminar Universidad'),
    content: Text('¿Deseas eliminar a ${universidad.nombre}?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      TextButton(
        onPressed: () async {
          await service.eliminarUniversidad(universidad.id);
          Navigator.pop(context);
        },
        child: const Text('Eliminar'),
      ),
    ],
  ),
);
```

---

## ✅ Validar Campos

```dart
import 'utils/validators.dart';

// Validar individual
String? error = Validators.validateNit('890.123.456-7');
if (error != null) {
  print('Error: $error');
}

// En TextFormField
TextFormField(
  validator: Validators.validateNombre,
  // ... otros parámetros
)

// Formatear
final nitFormateado = Validators.formatNit('890123456789');
final telFormateado = Validators.formatTelefono('576022242202');
```

---

## 🎨 Personalizar

### Cambiar colores
```dart
// En main.dart
theme: ThemeData(
  primarySwatch: Colors.blue,  // Cambiar a Colors.green, etc.
)

// En widgets
backgroundColor: Colors.blue.shade600,  // Personalizar
```

### Cambiar nombre colección
```dart
// En universidad_service.dart
final String _collectionName = 'mis_universidades';  // Cambiar
```

### Agregar más campos
```dart
// 1. Modificar clase Universidad en models/universidad.dart
// 2. Agregar campo a toFirestore() y fromFirestore()
// 3. Agregar TextFormField en views/universidad_form_view.dart
// 4. Agregar validador en utils/validators.dart
```

---

## 🧪 Pruebas Manuales

### Test 1: Crear
1. Presiona "+"
2. Completa campos
3. Presiona "Crear"
4. Verifica que aparece en listado

### Test 2: Editar
1. Presiona "Editar" en una card
2. Modifica datos
3. Presiona "Actualizar"
4. Verifica cambios

### Test 3: Eliminar
1. Presiona "Eliminar" en una card
2. Confirma
3. Verifica que desaparece

### Test 4: Tiempo Real
1. Abre en 2 dispositivos
2. Crea en uno
3. Verifica que aparece en otro

---

## 🐛 Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| "Target of URI doesn't exist" | Paquete no instalado | `flutter pub get` |
| "google-services.json not found" | Archivo faltante | Coloca en android/app/ |
| "Unauthorized" | Reglas Firestore | Verifica permiso de lectura/escritura |
| "Collection not found" | Colección no existe | Crea en Firebase Console |
| "Network error" | Sin internet | Verifica conexión emulador |

---

## 📱 Estados Posibles

```
ListadoUniversidades
├── Loading (CircularProgressIndicator)
├── Error (ErrorWidget + botón reintentar)
├── Empty (EmptyStateWidget + botón crear)
└── Success (ListView con Cards)

FormularioUniversidad
├── Loading (Spinner en botón)
└── Normal (Campos completables)
```

---

## 🔑 Métodos Importantes

### UniversidadService
```dart
obtenerUniversidadesStream()        // Stream<List<Universidad>>
obtenerUniversidades()              // Future<List<Universidad>>
obtenerUniversidadPorId(String id)  // Future<Universidad?>
crearUniversidad(Universidad)        // Future<String>
actualizarUniversidad(String id, Universidad)  // Future<void>
eliminarUniversidad(String id)      // Future<void>
existeNit(String nit)               // Future<bool>
buscarPorNombre(String nombre)      // Future<List<Universidad>>
obtenerTotalUniversidades()         // Future<int>
```

### Validators
```dart
validateNit(String?)                // String?
validateNombre(String?)             // String?
validateDireccion(String?)          // String?
validateTelefono(String?)           // String?
validatePaginaWeb(String?)          // String?
formatNit(String nit)               // String
formatTelefono(String telefono)     // String
```

---

## 📚 Documentación Disponible

| Archivo | Tema |
|---------|------|
| README.md | Descripción y características |
| INICIO_RAPIDO.md | Primeros pasos |
| CONFIGURACION.md | Setup Firebase paso a paso |
| ARQUITECTURA.md | Diagramas y flujos |
| EJEMPLOS.md | Ejemplos de código |

---

## 🎯 Próximos Pasos

1. **Básico**
   - [ ] Crear una universidad
   - [ ] Ver listado actualizado
   - [ ] Editar una universidad
   - [ ] Eliminar una universidad

2. **Intermedio**
   - [ ] Agregar búsqueda por nombre
   - [ ] Agregar filtros
   - [ ] Implementar caché local
   - [ ] Agregar fotos de perfil

3. **Avanzado**
   - [ ] Autenticación con Firebase Auth
   - [ ] Reglas de seguridad por usuario
   - [ ] Sincronización offline
   - [ ] Exportar a PDF
   - [ ] Gráficos y reportes

---

## 🔗 Enlaces Importantes

- [Firebase Console](https://console.firebase.google.com)
- [Flutter Firebase Docs](https://firebase.flutter.dev)
- [Firestore Docs](https://firebase.google.com/docs/firestore)
- [Material Design](https://material.io/design)

---

## ❓ Preguntas Frecuentes

### ¿Cómo cambio el idioma a inglés?
Modifica los strings en los archivos Dart.

### ¿Puedo agregar más campos?
Sí, modifica Universidad.dart, el servicio y el formulario.

### ¿Es seguro para producción?
No, requiere autenticación y reglas de seguridad mejoradas.

### ¿Funciona sin internet?
No, requiere conexión para Firestore. Puede implementarse caché offline.

### ¿Cómo escalo a muchos usuarios?
Implementa autenticación y reglas de seguridad basadas en usuario.

---

## 📞 Contacto

Si tienes dudas, revisa la documentación en la carpeta del proyecto.

---

*Referencia rápida para Taller Firebase - Gestión de Universidades*
