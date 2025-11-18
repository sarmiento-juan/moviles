# Guia Rapida - API Colombia App

## Inicio Rapido

### 1. Configuracion Inicial

```bash
# Asegurate de tener el archivo .env en la raiz
# con la siguiente linea:
API_COLOMBIA_URL=https://api-colombia.com
```

### 2. Ejecutar la Aplicacion

```bash
flutter run -t lib/parcial_de_prueba/main.dart
```

## Estructura de Navegacion

```
Dashboard (/)
    |
    |-- Departamentos (/departments)
    |       |
    |       |-- Detalle (/departments/:id)
    |
    |-- Presidentes (/presidents)
    |       |
    |       |-- Detalle (/presidents/:id)
    |
    |-- Atracciones (/attractions)
    |       |
    |       |-- Detalle (/attractions/:id)
    |
    |-- Aeropuertos (/airports)
            |
            |-- Detalle (/airports/:id)
```

## Caracteristicas por Pantalla

### Dashboard
- 4 cards interactivas (Departamentos, Presidentes, Atracciones, Aeropuertos)
- Card informativa sobre la API
- Colores basados en la bandera de Colombia

### Listados
- ListView.builder eficiente
- Pull to refresh
- Boton refresh en AppBar
- Estados: Loading, Success, Error, Empty
- Navegacion al detalle con tap

### Detalles
- Header con imagen/gradiente
- Informacion completa organizada en secciones
- Funcionalidad de copiar al portapapeles
- Boton back automatico

## Manejo de Estados

Cada vista implementa:

1. **Loading State**
   ```dart
   if (_isLoading) {
     return LoadingWidget(message: 'Cargando...');
   }
   ```

2. **Error State**
   ```dart
   if (_error != null) {
     return ErrorWidget(
       message: _error!,
       onRetry: _loadData,
     );
   }
   ```

3. **Empty State**
   ```dart
   if (_data.isEmpty) {
     return EmptyStateWidget(
       message: 'No hay datos',
       icon: Icons.inbox_outlined,
     );
   }
   ```

4. **Success State**
   ```dart
   return ListView.builder(...);
   ```

## Navegacion

### Ir al Listado
```dart
context.go('/departments');
```

### Ir al Detalle
```dart
context.go(
  '/departments/${department.id}',
  extra: department,
);
```

### Volver Atras
```dart
context.pop();
```

## Servicios HTTP

Patron de uso:

```dart
final service = DepartmentService();

try {
  final data = await service.getAllDepartments();
  setState(() {
    _departments = data;
    _isLoading = false;
  });
} catch (e) {
  setState(() {
    _error = e.toString();
    _isLoading = false;
  });
}
```

## Testing Local

### Probar sin Conexion
1. Desconecta el internet
2. Abre la app
3. Deberia mostrar el estado de error
4. Presiona "Reintentar"
5. Reconecta internet
6. Deberia cargar correctamente

### Probar Pull to Refresh
1. Navega a cualquier listado
2. Desliza hacia abajo
3. Deberia recargar los datos

### Probar Navegacion
1. Dashboard → Tap en card
2. Listado → Tap en item
3. Detalle → Tap en boton back
4. Verificar que vuelve al listado

## Errores Comunes

### Error: No se carga la API
**Solucion**: Verifica que el archivo `.env` existe y contiene:
```env
API_COLOMBIA_URL=https://api-colombia.com
```

### Error: No navega al detalle
**Solucion**: Verifica que estas pasando el objeto correcto en `extra`:
```dart
context.go('/departments/${dept.id}', extra: dept);
```

### Error: Widgets no se actualizan
**Solucion**: Asegurate de usar `setState()` al actualizar variables:
```dart
setState(() {
  _data = newData;
});
```

## Proximos Pasos

- [ ] Implementar busqueda en listados
- [ ] Agregar favoritos con almacenamiento local
- [ ] Implementar cache de datos
- [ ] Agregar paginacion en listados largos
- [ ] Mejorar manejo de imagenes con loading
- [ ] Agregar tests unitarios
- [ ] Implementar tests de integracion

## Contacto

Para dudas o sugerencias, contactar al equipo de desarrollo.
