# Ejemplos de Uso - API del Servicio

Ejemplos prácticos de cómo usar `UniversidadService` en tu aplicación.

---

## 📖 Ejemplos Básicos

### Crear una Universidad

```dart
import 'services/universidad_service.dart';
import 'models/universidad.dart';

final service = UniversidadService();

// Crear nueva universidad
final universidad = Universidad(
  id: '', // Se auto-genera
  nit: '890.123.456-7',
  nombre: 'UCEVA',
  direccion: 'Cra 27A #48-144, Tuluá - Valle',
  telefono: '+57 602 2242202',
  paginaWeb: 'https://www.uceva.edu.co',
);

// Guardar en Firestore
final id = await service.crearUniversidad(universidad);
print('Universidad creada con ID: $id');
```

### Obtener todas las universidades

```dart
// Opción 1: Futuro (una sola vez)
final universidades = await service.obtenerUniversidades();

// Opción 2: Stream (en tiempo real)
final stream = service.obtenerUniversidadesStream();
stream.listen((universidades) {
  print('Universidades actualizadas: ${universidades.length}');
});
```

### Obtener una universidad específica

```dart
final universidad = await service.obtenerUniversidadPorId('ABC123');

if (universidad != null) {
  print('Encontrada: ${universidad.nombre}');
} else {
  print('No encontrada');
}
```

### Actualizar una universidad

```dart
final universidadActualizada = universidad.copyWith(
  nombre: 'UCEVA - Universidad Colombiana',
  telefono: '+57 602 9999999',
);

await service.actualizarUniversidad(universidad.id, universidadActualizada);
```

### Eliminar una universidad

```dart
await service.eliminarUniversidad(universidad.id);
```

---

## 🎨 Ejemplos en Widgets

### Usar Stream en StreamBuilder

```dart
StreamBuilder<List<Universidad>>(
  stream: UniversidadService().obtenerUniversidadesStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    
    final universidades = snapshot.data ?? [];
    
    return ListView.builder(
      itemCount: universidades.length,
      itemBuilder: (context, index) {
        final uni = universidades[index];
        return ListTile(
          title: Text(uni.nombre),
          subtitle: Text(uni.nit),
        );
      },
    );
  },
)
```

### Usar Future con FutureBuilder

```dart
FutureBuilder<List<Universidad>>(
  future: UniversidadService().obtenerUniversidades(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    
    final universidades = snapshot.data ?? [];
    
    return Text('Total de universidades: ${universidades.length}');
  },
)
```

---

## 🔍 Ejemplos de Búsqueda

### Buscar por NIT

```dart
Future<Universidad?> buscarPorNit(String nit) async {
  final universidades = await service.obtenerUniversidades();
  
  try {
    return universidades.firstWhere((u) => u.nit == nit);
  } catch (e) {
    return null; // No encontrada
  }
}

// Uso
final uceva = await buscarPorNit('890.123.456-7');
```

### Buscar por nombre

```dart
// Usar el método de búsqueda del servicio
final resultados = await service.buscarPorNombre('UCEVA');
print('Encontradas: ${resultados.length} universidades');
```

### Filtrar localmente

```dart
final universidades = await service.obtenerUniversidades();

// Filtrar por ciudad
final unisValleDelCauca = universidades
    .where((u) => u.direccion.contains('Valle'))
    .toList();

// Filtrar por nombre
final unisConE = universidades
    .where((u) => u.nombre.toLowerCase().contains('e'))
    .toList();
```

---

## ✅ Ejemplos de Validación

### Validar antes de guardar

```dart
import 'utils/validators.dart';

final nit = '890.123.456-7';
final nombre = 'UCEVA';
final pagina = 'https://www.uceva.edu.co';

// Validar cada campo
String? errorNit = Validators.validateNit(nit);
String? errorNombre = Validators.validateNombre(nombre);
String? errorPagina = Validators.validatePaginaWeb(pagina);

if (errorNit == null && errorNombre == null && errorPagina == null) {
  print('Datos válidos, puede guardar');
} else {
  print('Errores: $errorNit, $errorNombre, $errorPagina');
}
```

### Formatear datos

```dart
import 'utils/validators.dart';

final nit = '890123456789';
final telefonoFormateado = Validators.formatTelefono('576022242202');

print(Validators.formatNit(nit));           // 890.123.456-7
print(telefonoFormateado);                   // +57 602 224 2202
```

---

## 🔐 Ejemplos con Manejo de Errores

### Try-Catch en creación

```dart
try {
  final id = await service.crearUniversidad(universidad);
  print('Creada con éxito: $id');
} on FirebaseException catch (e) {
  print('Error Firebase: ${e.code} - ${e.message}');
} catch (e) {
  print('Error desconocido: $e');
}
```

### Verificar si existe NIT

```dart
Future<bool> verificarNitExiste(String nit) async {
  try {
    return await service.existeNit(nit);
  } catch (e) {
    print('Error al verificar NIT: $e');
    return false;
  }
}

// Uso
if (await verificarNitExiste('890.123.456-7')) {
  print('El NIT ya está registrado');
} else {
  print('NIT disponible');
}
```

### Manejo de operación larga

```dart
// Con indicador visual
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Guardando...'),
    content: const CircularProgressIndicator(),
  ),
);

try {
  await service.crearUniversidad(universidad);
} catch (e) {
  print('Error: $e');
} finally {
  Navigator.pop(context);
}
```

---

## 🔄 Ejemplos con Estado

### Usando StatefulWidget

```dart
class MiWidget extends StatefulWidget {
  @override
  State<MiWidget> createState() => _MiWidgetState();
}

class _MiWidgetState extends State<MiWidget> {
  final service = UniversidadService();
  List<Universidad> universidades = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _cargarUniversidades();
  }

  Future<void> _cargarUniversidades() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final datos = await service.obtenerUniversidades();
      setState(() => universidades = datos);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const CircularProgressIndicator();
    if (error != null) return Text('Error: $error');
    
    return ListView(
      children: universidades.map((uni) {
        return ListTile(title: Text(uni.nombre));
      }).toList(),
    );
  }
}
```

---

## 📊 Ejemplo Completo: Formulario CRUD

```dart
class FormularioCompleto extends StatefulWidget {
  @override
  State<FormularioCompleto> createState() => _FormularioCompletoState();
}

class _FormularioCompletoState extends State<FormularioCompleto> {
  final _formKey = GlobalKey<FormState>();
  final service = UniversidadService();
  
  late TextEditingController _nombreController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final universidad = Universidad(
        id: '',
        nit: 'NIT123',
        nombre: _nombreController.text,
        direccion: 'Dirección',
        telefono: '+57',
        paginaWeb: 'https://web.com',
      );

      await service.crearUniversidad(universidad);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Guardado!')),
        );
        _nombreController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nombreController,
            validator: Validators.validateNombre,
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _guardar,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }
}
```

---

## 🚨 Casos de Error Comunes

### Error 1: "Unauthorized"
```
// Causa: Las reglas de Firestore no lo permiten
// Solución: Revisar reglas en Firebase Console
```

### Error 2: "Collection not found"
```
// Causa: La colección no existe en Firestore
// Solución: Crearla en Firebase Console
```

### Error 3: "Network error"
```
// Causa: Sin conexión a internet
// Solución: Verificar conexión del emulador
```

---

## 📝 Resumen de Métodos

| Método | Parámetro | Retorna | Uso |
|--------|-----------|---------|-----|
| `obtenerUniversidadesStream()` | - | `Stream<List<Universidad>>` | Datos en tiempo real |
| `obtenerUniversidades()` | - | `Future<List<Universidad>>` | Todos los datos (una vez) |
| `obtenerUniversidadPorId()` | String id | `Future<Universidad?>` | Buscar por ID |
| `crearUniversidad()` | Universidad | `Future<String>` | Crear nueva |
| `actualizarUniversidad()` | String id, Universidad | `Future<void>` | Actualizar existente |
| `eliminarUniversidad()` | String id | `Future<void>` | Eliminar |
| `existeNit()` | String nit | `Future<bool>` | Verificar NIT |
| `buscarPorNombre()` | String nombre | `Future<List<Universidad>>` | Buscar por nombre |
| `obtenerTotalUniversidades()` | - | `Future<int>` | Cantidad total |

---

*Ejemplos de uso para UniversidadService y componentes relacionados*
