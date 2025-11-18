# Resumen Visual - Gestión de Universidades Firebase

## 🏗️ Arquitectura de la Aplicación

```
┌─────────────────────────────────────────────────────────┐
│                      APP PRINCIPAL                       │
│                    (main.dart)                           │
│              MaterialApp con navegación                  │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┴───────────────┐
        │                            │
        ▼                            ▼
┌──────────────────┐      ┌──────────────────┐
│   LIST VIEW      │      │   FORM VIEW      │
│  (Stream Realtime)│     │ (Crear/Editar)   │
└────────┬─────────┘      └──────┬───────────┘
         │                        │
         └────────────┬───────────┘
                      │
              ┌───────▼────────┐
              │  UNIVERSIDADES │
              │   SERVICE      │
              │                │
              │ - Create       │
              │ - Read         │
              │ - Update       │
              │ - Delete       │
              └───────┬────────┘
                      │
              ┌───────▼────────┐
              │  FIRESTORE     │
              │  DATABASE      │
              │  (Cloud)       │
              └────────────────┘
```

---

## 📱 Flujo de Pantallas

```
┌─────────────────────────────────────────────────────────┐
│                  SPLASH / INICIO                         │
│                                                           │
│  WidgetsFlutterBinding.ensureInitialized()              │
│  Firebase.initializeApp()                               │
│  → Material App inicia                                  │
└──────────────────────┬────────────────────────────────┘
                       │
        ┌──────────────▼──────────────┐
        │    PANTALLA LISTADO         │
        │                             │
        │ • Stream de universidades  │
        │ • Pull to refresh          │
        │ • FAB: Crear nuevo         │
        │ • Card: Editar/Eliminar    │
        │                             │
        │ Si vacío → EmptyState      │
        │ Si error → ErrorWidget     │
        │ Si carga → LoadingWidget   │
        └──────────┬──────────┬──────┘
                   │          │
            Crear  │          │ Editar
                   │          │
        ┌──────────▼──────────▼──────────┐
        │      PANTALLA FORMULARIO       │
        │                                │
        │ • TextFormField x5             │
        │ • Validadores integrados       │
        │ • Botón Guardar/Actualizar     │
        │ • Botón Cancelar               │
        │                                │
        │ Guardar → UniversidadService   │
        │           → crearUniversidad() │
        │           → actualizarUniversidad() │
        └──────────┬─────────────────────┘
                   │
                   │ Volver
                   ▼
        ┌──────────────────────┐
        │  PANTALLA LISTADO    │
        │ (actualizada en      │
        │  tiempo real)        │
        └──────────────────────┘
```

---

## 🗄️ Estructura de Datos

### Firestore Collection: `universidades`

```json
universidades/
├── doc_id_1/
│   ├── nit: "890.123.456-7"
│   ├── nombre: "UCEVA"
│   ├── direccion: "Cra 27A #48-144, Tuluá - Valle"
│   ├── telefono: "+57 602 2242202"
│   └── pagina_web: "https://www.uceva.edu.co"
│
├── doc_id_2/
│   ├── nit: "899.123.456-1"
│   ├── nombre: "Universidad Nacional"
│   ├── direccion: "Cra 45 #26-85, Bogotá"
│   ├── telefono: "+57 1 3165000"
│   └── pagina_web: "https://www.unal.edu.co"
│
└── doc_id_3/
    ├── nit: "891.222.333-4"
    ├── nombre: "Pontificia Universidad Javeriana"
    ├── direccion: "Cra 7 #40-62, Bogotá"
    ├── telefono: "+57 1 3208300"
    └── pagina_web: "https://www.javeriana.edu.co"
```

---

## 📊 Diagrama de Componentes

```
┌────────────────────────────────────────────────────────────┐
│                        MAIN.DART                            │
│         Punto de entrada y configuración                   │
│                                                             │
│  • MaterialApp                                             │
│  • Theme personalizado                                     │
│  • Routes definidas                                        │
│  • Home: UniversidadesListView                             │
└────────────────────────────────────────────────────────────┘

┌───────────────────────┐         ┌───────────────────────┐
│    VIEWS              │         │    MODELS             │
│                       │         │                       │
│ • universidades_      │         │ • universidad.dart    │
│   list_view.dart      │────────→│   - fromFirestore()   │
│   (Stream en tiempo   │         │   - toFirestore()     │
│    real)              │         │   - copyWith()        │
│                       │         │                       │
│ • universidad_        │         │                       │
│   form_view.dart      │         │                       │
│   (Crear/Editar con   │         │                       │
│    validaciones)      │         │                       │
└──────────┬────────────┘         └─────────────────────┬─┘
           │                                             │
           │              ┌──────────────────────────────┘
           │              │
           ▼              ▼
┌────────────────────────────────────────────────────────┐
│          SERVICES                                       │
│                                                         │
│  UniversidadService:                                   │
│  • obtenerUniversidadesStream()                        │
│  • obtenerUniversidades()                              │
│  • obtenerUniversidadPorId()                           │
│  • crearUniversidad()                                  │
│  • actualizarUniversidad()                             │
│  • eliminarUniversidad()                               │
│  • existeNit()                                         │
│  • buscarPorNombre()                                   │
│  • obtenerTotalUniversidades()                         │
└────────────┬─────────────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────────────────────┐
│          FIRESTORE DATABASE                             │
│          (Cloud Firebase)                               │
│                                                         │
│  Colección: universidades                              │
│  - Lectura: Permitida                                  │
│  - Escritura: Permitida                                │
│  - Tiempo real: Sí (Stream)                            │
└────────────────────────────────────────────────────────┘

┌──────────────────────┐        ┌──────────────────────┐
│     WIDGETS          │        │     UTILS            │
│                      │        │                      │
│ • universidad_card   │        │ • validators.dart    │
│   (Muestra info)     │        │   - validateNit()    │
│                      │        │   - validateNombre() │
│ • loading_widget     │        │   - validateDireccion()
│   (Indicador carga)  │        │   - validateTelefono()
│                      │        │   - validatePaginaWeb()
│ • error_widget       │        │   - formatNit()      │
│   (Mensaje error)    │        │   - formatTelefono() │
│                      │        │                      │
│ • empty_state_       │        │                      │
│   widget             │        │                      │
│   (Sin datos)        │        │                      │
└──────────────────────┘        └──────────────────────┘
```

---

## 🔄 Ciclo de Vida - Crear Universidad

```
1. Usuario presiona botón "+"
   │
   ▼
2. Navega a UniversidadFormView (vacío)
   │
   ▼
3. Usuario completa formulario
   │
   ├─ NIT: 890.123.456-7
   ├─ Nombre: UCEVA
   ├─ Dirección: Cra 27A #48-144
   ├─ Teléfono: +57 602 2242202
   └─ Página Web: https://www.uceva.edu.co
   │
   ▼
4. Usuario presiona "Crear"
   │
   ▼
5. Validar en cliente
   │
   ├─ ¿NIT válido? (8+ dígitos)
   ├─ ¿Nombre válido? (3-100 caracteres)
   ├─ ¿Dirección válida? (5+ caracteres)
   ├─ ¿Teléfono válido? (7+ dígitos)
   └─ ¿Página web válida? (URL con protocolo)
   │
   ├─ Si hay error → Mostrar en campo
   └─ Si OK → Continuar
   │
   ▼
6. Mostrar indicador de carga
   │
   ▼
7. Enviar a UniversidadService.crearUniversidad()
   │
   ▼
8. Service crea objeto Universidad
   │
   ▼
9. Llama a Firestore.collection('universidades').add()
   │
   ▼
10. Firebase genera ID automático
    │
    ▼
11. Guarda documento en Firestore
    │
    ▼
12. Retorna ID del documento
    │
    ▼
13. Mostrar SnackBar: "Universidad creada exitosamente"
    │
    ▼
14. Volver a UniversidadesListView
    │
    ▼
15. Stream detecta cambio en Firestore
    │
    ▼
16. StreamBuilder reconstruye ListView
    │
    ▼
17. Nueva universidad aparece en lista
```

---

## 🔄 Ciclo de Vida - Stream en Tiempo Real

```
┌─────────────────────────────────────────┐
│  UniversidadesListView - initState()    │
│                                         │
│  _universidadesStream =                 │
│    _service.obtenerUniversidadesStream()│
└────────────────┬────────────────────────┘
                 │
                 ▼
        ┌─────────────────┐
        │ StreamBuilder   │
        │   escucha       │
        │ cambios en      │
        │ Firestore       │
        └────────┬────────┘
                 │
    ┌────────────┴────────────┐
    │                         │
Documento            Documento
 creado               actualizado
    │                         │
    ▼                         ▼
┌─────────────────────────────────────┐
│ Firestore detecta cambio            │
│ (Listener activo)                   │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│ Emite nuevo snapshot con datos      │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│ StreamBuilder recibe cambio         │
│ builder() se ejecuta                │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│ ListView.builder reconstruye        │
│ con nuevos datos                    │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│ Usuario ve cambios en tiempo real   │
│ (sin recargar la pantalla)          │
└─────────────────────────────────────┘
```

---

## 📋 Estados Posibles - ListView

```
Estado 1: CARGANDO
┌────────────────────────┐
│  ⟳ Cargando datos...   │
└────────────────────────┘

Estado 2: ERROR
┌──────────────────────────────────┐
│ ⚠ Error al cargar universidades  │
│                                   │
│ [Reintentar]                      │
└──────────────────────────────────┘

Estado 3: VACÍO
┌──────────────────────────────────┐
│ 📭 Sin Universidades              │
│                                   │
│ Aún no hay universidades         │
│ registradas.                      │
│ Crea una nueva para comenzar.     │
│                                   │
│ [Crear Universidad]               │
└──────────────────────────────────┘

Estado 4: CON DATOS
┌──────────────────────────────────┐
│ Universidades (Pull to refresh)  │
│                                   │
│ ┌────────────────────────────────┐│
│ │ 🏫 UCEVA                        ││
│ │ NIT: 890.123.456-7             ││
│ │ ─────────────────────────────  ││
│ │ 📍 Cra 27A #48-144, Tuluá     ││
│ │ 📞 +57 602 2242202            ││
│ │ 🌐 https://www.uceva.edu.co   ││
│ │              [Editar] [Eliminar]││
│ └────────────────────────────────┘│
│                                    │
│ ┌────────────────────────────────┐│
│ │ 🏫 Universidad Nacional        ││
│ │ NIT: 899.123.456-1             ││
│ │ ─────────────────────────────  ││
│ │ 📍 Cra 45 #26-85, Bogotá      ││
│ │ 📞 +57 1 3165000              ││
│ │ 🌐 https://www.unal.edu.co   ││
│ │              [Editar] [Eliminar]││
│ └────────────────────────────────┘│
│                                    │
│                       [➕ Nueva]   │
└──────────────────────────────────┘
```

---

## ✅ Flujo de Validación - Formulario

```
Campo: NIT
├─ Vacío? → Error: "El NIT es requerido"
├─ < 8 dígitos? → Error: "Al menos 8 dígitos"
└─ Válido → ✓ Verde

Campo: Nombre
├─ Vacío? → Error: "El nombre es requerido"
├─ < 3 caracteres? → Error: "Al menos 3 caracteres"
├─ > 100 caracteres? → Error: "Máximo 100 caracteres"
└─ Válido → ✓ Verde

Campo: Dirección
├─ Vacío? → Error: "La dirección es requerida"
├─ < 5 caracteres? → Error: "Al menos 5 caracteres"
└─ Válido → ✓ Verde

Campo: Teléfono
├─ Vacío? → Error: "El teléfono es requerido"
├─ < 7 dígitos? → Error: "Al menos 7 dígitos"
└─ Válido → ✓ Verde

Campo: Página Web
├─ Vacío? → Error: "La página web es requerida"
├─ ¿Contiene http(s)://? No → Error
├─ ¿Es URL válida? No → Error
└─ Válido → ✓ Verde

Formulario Completo
├─ ¿Todos los campos verdes? Sí
└─ Botón "Guardar/Actualizar" habilitado ✓
```

---

## 🎨 Paleta de Colores

```
Primario
├─ Colors.blue.shade600 (AppBar, FAB, Botones)
└─ #1976D2

Secundario
├─ Colors.blue.shade400 (Gradientes)
└─ #42A5F5

Fondo
├─ Colors.grey.shade50 (TextFormField)
└─ #FAFAFA

Texto
├─ Colors.black (Títulos)
├─ Colors.grey.shade600 (Subtítulos)
└─ Colors.grey.shade800 (Cuerpo)

Errores
├─ Colors.red (Botón eliminar, avisos)
└─ #F44336

Éxito
├─ Colors.green (Confirmaciones)
└─ #4CAF50
```

---

## 📦 Resumen de Archivos

| Archivo | Líneas | Propósito |
|---------|--------|----------|
| `main.dart` | ~60 | Punto de entrada, MaterialApp, rutas |
| `models/universidad.dart` | ~70 | Modelo de datos, conversión |
| `services/universidad_service.dart` | ~150 | Lógica CRUD con Firestore |
| `views/universidades_list_view.dart` | ~140 | Listado con Stream |
| `views/universidad_form_view.dart` | ~200 | Formulario crear/editar |
| `widgets/universidad_card.dart` | ~180 | Card de información |
| `widgets/loading_widget.dart` | ~25 | Indicador carga |
| `widgets/error_widget.dart` | ~40 | Mensaje de error |
| `widgets/empty_state_widget.dart` | ~55 | Estado vacío |
| `utils/validators.dart` | ~130 | Validadores y formateadores |
| **TOTAL** | **~1,045** | **Código funcional completo** |

---

## 🎯 Checklist de Implementación

- [x] Modelo Universidad con conversión Firestore
- [x] Servicio CRUD completo
- [x] Vista de listado con Stream
- [x] Vista de formulario con validaciones
- [x] Widgets reutilizables (Card, Loading, Error, Empty)
- [x] Validadores de campos
- [x] Manejo de errores
- [x] Navegación entre vistas
- [x] Tema personalizado
- [x] Documentación completa
- [x] Ejemplos de uso
- [x] Guía de configuración

---

*Resumen visual de la arquitectura y flujos de la aplicación*
