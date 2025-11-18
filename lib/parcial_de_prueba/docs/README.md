# Documentacion Tecnica - API Colombia App

Bienvenido a la documentacion tecnica completa de la aplicacion **API Colombia**. Esta carpeta contiene toda la informacion sobre el desarrollo, arquitectura y funcionamiento del proyecto.

## Contenido de la Documentacion

### 📄 [DESARROLLO.md](./DESARROLLO.md)
**Documentacion principal del desarrollo**

Contenido:
- Vision general del proyecto
- Proceso de desarrollo (4 fases)
- Explicacion detallada de cada carpeta
- Explicacion de cada archivo
- Flujo de funcionamiento completo
- Decisiones tecnicas justificadas
- Resumen estadistico

**Ideal para**: Entender como esta construida la aplicacion y por que se tomaron ciertas decisiones.

---

### 📊 [DIAGRAMAS.md](./DIAGRAMAS.md)
**Diagramas visuales y flujos**

Contenido:
- Arquitectura general (diagrama)
- Flujo de datos de API a UI
- Flujo de estados (loading/success/error)
- Mapa de rutas de navegacion
- Stack de navegacion
- Ciclo de vida de una vista
- Flujo HTTP request detallado
- Estructura de archivos visual
- Flujo completo paso a paso
- Paleta de colores

**Ideal para**: Visualizar como funcionan los componentes y como fluyen los datos.

---

## Guia Rapida de Lectura

### Si quieres entender la arquitectura:
1. Lee la seccion "Vision General" en `DESARROLLO.md`
2. Revisa el diagrama "Arquitectura General" en `DIAGRAMAS.md`
3. Lee "Estructura de Carpetas" en `DESARROLLO.md`

### Si quieres entender el flujo de datos:
1. Revisa "Flujo de Datos" en `DIAGRAMAS.md`
2. Lee "Flujo de Funcionamiento" en `DESARROLLO.md`
3. Estudia "Flujo Completo" en `DIAGRAMAS.md`

### Si quieres entender cada carpeta:
1. Ve a "Estructura de Carpetas" en `DESARROLLO.md`
2. Lee cada carpeta en orden:
   - models/ → services/ → views/ → widgets/ → routes/ → themes/

### Si quieres entender las decisiones tecnicas:
1. Lee "Decisiones Tecnicas" en `DESARROLLO.md`
2. Revisa "Proceso de Desarrollo" para contexto

---

## Resumen Ejecutivo

### Datos del Proyecto

| Aspecto | Detalle |
|---------|---------|
| **Nombre** | API Colombia Consumer |
| **Framework** | Flutter 3.35.3 |
| **Lenguaje** | Dart 3.9.2 |
| **API** | https://api-colombia.com |
| **Endpoints** | 12 (4 recursos × 3 operaciones) |
| **Archivos** | 24 archivos de codigo |
| **Lineas** | ~3,310 lineas totales |
| **Arquitectura** | MVC por capas |
| **Navegacion** | go_router (declarativa) |
| **HTTP Client** | http package |

### Recursos de la API

1. **Department** (Departamentos)
   - 32 departamentos de Colombia
   - Municipios, poblacion, superficie

2. **President** (Presidentes)
   - Historia presidencial
   - Periodos, partidos politicos

3. **TouristicAttraction** (Atracciones)
   - Lugares turisticos
   - Galerias de imagenes, coordenadas

4. **Airport** (Aeropuertos)
   - Aeropuertos nacionales
   - Codigos OACI/IATA

### Estructura del Proyecto

```
parcial_de_prueba/
├── models/       (4 archivos)  - Estructura de datos
├── services/     (4 archivos)  - Logica de API
├── views/        (9 archivos)  - Pantallas UI
├── widgets/      (4 archivos)  - Componentes reusables
├── routes/       (1 archivo)   - Navegacion
├── themes/       (1 archivo)   - Estilos globales
└── main.dart     (1 archivo)   - Entry point

Total: 24 archivos
```

### Paquetes Principales

- **http** ^1.2.2 - Peticiones HTTP
- **go_router** ^14.6.2 - Navegacion
- **flutter_dotenv** ^5.2.1 - Variables de entorno

---

## Como Usar Esta Documentacion

### Para Desarrolladores Nuevos
1. Empieza con este archivo (README.md)
2. Lee `DESARROLLO.md` completo
3. Revisa los diagramas en `DIAGRAMAS.md`
4. Explora el codigo fuente con el contexto aprendido

### Para Code Review
1. Revisa "Decisiones Tecnicas" en `DESARROLLO.md`
2. Verifica arquitectura en `DIAGRAMAS.md`
3. Compara codigo con las explicaciones

### Para Mantenimiento
1. Identifica la capa afectada (models/services/views/widgets)
2. Lee la explicacion de esa carpeta en `DESARROLLO.md`
3. Revisa el flujo correspondiente en `DIAGRAMAS.md`

### Para Expansion del Proyecto
1. Entiende el patron actual en `DESARROLLO.md`
2. Replica la estructura para nuevo recurso
3. Sigue las mismas convenciones

---

## Estructura de Documentacion

```
docs/
├── README.md        (Este archivo - Indice general)
├── DESARROLLO.md    (Desarrollo y explicacion detallada)
└── DIAGRAMAS.md     (Diagramas y flujos visuales)
```

---

## Glosario de Terminos

- **Endpoint**: URL especifica de la API que retorna datos
- **Model**: Clase Dart que representa estructura de datos
- **Service**: Clase que maneja peticiones HTTP
- **View**: Pantalla completa de la aplicacion
- **Widget**: Componente reutilizable de UI
- **Route**: Configuracion de navegacion
- **Theme**: Configuracion de estilos globales
- **setState**: Metodo que actualiza estado y UI
- **context.push**: Navegar a nueva pantalla (apila)
- **context.pop**: Regresar a pantalla anterior
- **fromJson**: Convertir JSON a objeto Dart
- **toJson**: Convertir objeto Dart a JSON

---

## Contacto y Soporte

Para preguntas sobre la documentacion o el codigo:
- Revisa primero `DESARROLLO.md`
- Luego consulta `DIAGRAMAS.md`
- Busca en el codigo fuente con el contexto aprendido

---

## Version de la Documentacion

- **Version**: 1.0
- **Fecha**: Octubre 10, 2025
- **Autor**: Desarrollo Parcial API Colombia
- **Estado**: Completa y actualizada

---

## Actualizaciones Futuras

Esta documentacion debe actualizarse cuando:
- Se agreguen nuevos endpoints
- Se modifique la arquitectura
- Se agreguen nuevas features
- Se cambien paquetes principales

---

*Documentacion creada para facilitar el entendimiento del proyecto API Colombia*
