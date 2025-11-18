# Guion para Video - Explicacion de la Aplicacion API Colombia

## Informacion del Video
- **Duracion estimada**: 8-10 minutos
- **Tipo**: Tutorial tecnico / Demo de aplicacion
- **Audiencia**: Estudiantes, desarrolladores Flutter

---

## ESTRUCTURA DEL VIDEO

### SECCION 1: INTRODUCCION (1 minuto)
### SECCION 2: DEMOSTRACION DE LA APP (2-3 minutos)
### SECCION 3: ARQUITECTURA DEL PROYECTO (2 minutos)
### SECCION 4: CODIGO DETALLADO (4-5 minutos)
### SECCION 5: CIERRE (1 minuto)

---

## GUION DETALLADO

---

### 🎬 SECCION 1: INTRODUCCION (1 minuto)

**[PANTALLA: Logo de Flutter o titulo del proyecto]**

**DECIR:**
> "Hola, en este video les voy a mostrar mi proyecto de Flutter que consume la API publica de Colombia. Esta aplicacion demuestra el consumo de multiples endpoints REST, implementacion de arquitectura MVC, navegacion declarativa con go_router, y manejo completo de estados."

**[PANTALLA: Mostrar emulador con la app abierta]**

**DECIR:**
> "La aplicacion muestra informacion sobre cuatro recursos principales: Departamentos, Presidentes de Colombia, Atracciones Turisticas y Aeropuertos. En total, consumo 12 endpoints diferentes de la API Colombia."


### 📱 SECCION 2: DEMOSTRACION DE LA APP (2-3 minutos)

**[PANTALLA: Dashboard de la app]**

**DECIR:**
> "Empecemos con la demostracion. Esta es la pantalla principal o dashboard, que tiene cuatro cards con los colores de la bandera de Colombia: azul para departamentos, rojo para presidentes, amarillo para atracciones turisticas, y verde para aeropuertos."


**DECIR:**
> "Al tocar la card de Departamentos, navegamos a una lista que muestra los 32 departamentos de Colombia. Aqui podemos ver el nombre, numero de municipios y poblacion de cada uno."

**ACCIONES:**
1. Esperar a que cargue (mostrar el loading)
2. Hacer scroll por la lista
3. Señalar: "Vean que cada card tiene la inicial del departamento en un circulo"

**[ACCION: Hacer pull-to-refresh]**

**DECIR:**
> "La lista tiene la funcionalidad de pull-to-refresh, si deslizamos hacia abajo, vuelve a cargar los datos de la API."

**ACCIONES:**
- Deslizar hacia abajo y soltar
- Mostrar el indicador de carga

---

**[ACCION: Tocar un departamento, por ejemplo "Antioquia"]**

**DECIR:**
> "Al tocar cualquier departamento, vamos a la vista de detalle que muestra toda la informacion completa: nombre, numero de municipios, superficie, poblacion, prefijo telefonico, y una descripcion detallada."

**ACCIONES:**
1. Hacer scroll por la vista de detalle
2. Señalar cada seccion: header, estadisticas, descripcion
3. Mostrar el boton de copiar

**DECIR:**
> "Noten que hay un header con gradiente azul, seccion de estadisticas con los datos principales, y al final informacion tecnica donde podemos copiar el ID al portapapeles."

**[ACCION: Presionar boton de retroceso]**

**DECIR:**
> "Con el boton de retroceso regresamos a la lista. Esta navegacion esta implementada con go_router usando context.push y context.pop."

---

**[ACCION: Regresar al dashboard y tocar Presidentes]**

**DECIR:**
> "Ahora veamos la seccion de Presidentes. Aqui tenemos la lista de presidentes de Colombia con su nombre completo, periodo presidencial y partido politico. Algunos tienen foto de perfil."

**ACCIONES:**
1. Hacer scroll por la lista
2. Tocar un presidente

**[PANTALLA: Detalle de Presidente]**

**DECIR:**
> "En el detalle vemos la biografia completa: nombre, apellido, partido politico, y el periodo presidencial con fecha de inicio y fin. El tema de esta vista usa el color rojo de la bandera."

**ACCIONES:**
- Mostrar el header con imagen
- Hacer scroll por las secciones
- Regresar al dashboard

---

**[ACCION: Mostrar rapidamente Atracciones y Aeropuertos]**

**DECIR:**
> "Las otras dos secciones funcionan de manera similar. Atracciones Turisticas muestra lugares turisticos con galerias de imagenes y coordenadas. Y Aeropuertos muestra los aeropuertos nacionales con sus codigos OACI e IATA."

**ACCIONES:**
- Entrar rapidamente a cada seccion
- Mostrar una vista de lista y una de detalle
- No profundizar mucho, solo mostrar que funcionan igual

---

### 🏗️ SECCION 3: ARQUITECTURA DEL PROYECTO (2 minutos)

**[PANTALLA: VS Code - Estructura de carpetas]**

**DECIR:**
> "Ahora veamos como esta organizado el codigo. El proyecto sigue una arquitectura MVC por capas con la siguiente estructura:"

**ACCIONES:**
- Mostrar la carpeta `lib/parcial_de_prueba/`
- Expandir todas las carpetas

**DECIR:**
> "Tenemos seis carpetas principales mas el archivo main.dart:"

**[SEÑALAR cada carpeta mientras hablas]**

**DECIR:**
> "Uno: la carpeta MODELS, con cuatro archivos que definen la estructura de datos que vienen de la API. Aqui tenemos department, president, touristic_attraction y airport."

> "Dos: la carpeta SERVICES, con cuatro archivos que manejan todas las peticiones HTTP a la API. Cada servicio consume un recurso especifico."

> "Tres: la carpeta VIEWS, con nueve archivos que son las pantallas de la aplicacion. Tenemos el dashboard, cuatro vistas de lista, y cuatro vistas de detalle."

> "Cuatro: la carpeta WIDGETS, con cuatro componentes reutilizables: el dashboard card, loading widget, error widget, y empty state widget."

> "Cinco: la carpeta ROUTES, con un solo archivo que configura toda la navegacion usando go_router. Aqui se definen las doce rutas de la aplicacion."

> "Seis: la carpeta THEMES, con el tema global que usa los colores de la bandera de Colombia."

> "Y finalmente, main.dart que es el punto de entrada de la aplicacion."

**DECIR:**
> "En total son 24 archivos de codigo organizados en capas, lo que hace que el proyecto sea escalable y facil de mantener."

---

### 💻 SECCION 4: CODIGO DETALLADO (4-5 minutos)

#### 4.1 - MODELS (45 segundos)

**[PANTALLA: Abrir `models/department.dart`]**

**DECIR:**
> "Empecemos con los modelos. Este es el modelo de Department que representa un departamento de Colombia."

**ACCIONES:**
- Mostrar las propiedades de la clase
- Hacer scroll al metodo fromJson

**DECIR:**
> "Tiene propiedades como id, name, description, municipalities, surface, population y phonePrefix. Todas estas propiedades mapean directamente con los campos JSON que retorna la API."

**[SEÑALAR el metodo fromJson]**

**DECIR:**
> "El metodo fromJson convierte el JSON que recibimos de la API en un objeto Dart. Aqui parseamos cada campo: el ID como entero, el nombre como string, los municipios como entero, y asi con todos."

**[SEÑALAR el getter formattedPopulation]**

**DECIR:**
> "Y tenemos getters computados como formattedPopulation que formatea el numero de poblacion con comas para mejor legibilidad."

---

#### 4.2 - SERVICES (1 minuto)

**[PANTALLA: Abrir `services/department_service.dart`]**

**DECIR:**
> "Ahora veamos los servicios. Esta clase DepartmentService maneja todas las peticiones HTTP relacionadas con departamentos."

**[SEÑALAR la variable baseUrl]**

**DECIR:**
> "Primero, leemos la URL base desde las variables de entorno usando dotenv. Esto es una buena practica para no tener URLs hardcodeadas en el codigo."

**[HACER SCROLL al metodo getAllDepartments]**

**DECIR:**
> "El metodo getAllDepartments hace una peticion GET a la API. Construimos la URI completa concatenando la URL base con el endpoint."

**ACCIONES:**
- Señalar el http.get
- Señalar el statusCode == 200

**DECIR:**
> "Hacemos la peticion con http.get, esperamos la respuesta con await, y validamos que el statusCode sea 200 que significa exito."

**[SEÑALAR el json.decode y el map]**

**DECIR:**
> "Si fue exitoso, decodificamos el JSON, y mapeamos cada elemento del array a un objeto Department usando el fromJson que vimos antes."

**[SEÑALAR el catch]**

**DECIR:**
> "Y si hay algun error, lo atrapamos con try-catch y lanzamos una excepcion con un mensaje descriptivo."

**DECIR:**
> "Los otros servicios funcionan exactamente igual: president_service, touristic_attraction_service, y airport_service. Todos siguen el mismo patron."

---

#### 4.3 - VIEWS (1.5 minutos)

**[PANTALLA: Abrir `views/departments_list_view.dart`]**

**DECIR:**
> "Ahora las vistas. Esta es DepartmentsListView que muestra la lista de departamentos."

**[SEÑALAR el State]**

**DECIR:**
> "Es un StatefulWidget porque necesitamos estado mutable. Tenemos tres variables de estado: la lista de departamentos, un booleano para loading, y un string opcional para errores."

**[HACER SCROLL a initState]**

**DECIR:**
> "En el initState llamamos a loadDepartments que es el metodo que carga los datos."

**[MOSTRAR el metodo _loadDepartments]**

**DECIR:**
> "Este metodo primero pone isLoading en true con setState, luego llama al servicio para obtener los datos, y finalmente actualiza el estado con los departamentos o el error."

**[HACER SCROLL al build method]**

**DECIR:**
> "En el metodo build manejamos cuatro estados posibles:"

**ACCIONES:**
- Señalar cada if

**DECIR:**
> "Si esta cargando, mostramos el LoadingWidget. Si hay error, mostramos el ErrorWidget. Si no hay datos, mostramos el EmptyStateWidget. Y si todo esta bien, mostramos el ListView con los datos."

**[SEÑALAR el ListView.builder]**

**DECIR:**
> "El ListView.builder renderiza eficientemente la lista. Para cada departamento creamos una Card con su informacion: inicial en un circulo, nombre, numero de municipios y poblacion."

**[SEÑALAR el onTap]**

**DECIR:**
> "Y cuando el usuario toca una card, navegamos a la vista de detalle usando context.push, pasando el ID en la URL y el objeto completo en extra."

---

#### 4.4 - WIDGETS (45 segundos)

**[PANTALLA: Abrir `widgets/loading_widget.dart`]**

**DECIR:**
> "Los widgets son componentes reutilizables. Este es LoadingWidget que simplemente muestra un spinner con un mensaje opcional."

**[ABRIR `widgets/error_widget.dart`]**

**DECIR:**
> "ErrorWidget muestra un icono de error, un mensaje, y un boton opcional de reintentar."

**[ABRIR `widgets/dashboard_card.dart`]**

**DECIR:**
> "Y DashboardCard es la card que usamos en el dashboard. Recibe titulo, subtitulo, icono, color, y un callback onTap. Muestra todo con un degradado del color especificado."

**DECIR:**
> "La ventaja de tener widgets reutilizables es que evitamos duplicar codigo y mantenemos consistencia visual en toda la app."

---

#### 4.5 - ROUTES (45 segundos)

**[PANTALLA: Abrir `routes/app_router.dart`]**

**DECIR:**
> "La navegacion esta configurada aqui en app_router. Usamos go_router que es el paquete oficial recomendado por el equipo de Flutter."

**[SEÑALAR las rutas]**

**DECIR:**
> "Tenemos doce rutas definidas: la ruta raiz que muestra el dashboard, cuatro rutas para las listas, y cuatro rutas para los detalles que aceptan un parametro de ID."

**[SEÑALAR una ruta de detalle]**

**DECIR:**
> "Por ejemplo, esta ruta de detalle de departamento tiene el path '/departments/:id'. Parseamos el ID de los pathParameters y obtenemos el objeto Department del extra."

**DECIR:**
> "Esta configuracion declarativa hace que la navegacion sea mas clara y permite deep linking si quisieramos publicar la app en web."

---

#### 4.6 - MAIN.DART (30 segundos)

**[PANTALLA: Abrir `main.dart`]**

**DECIR:**
> "Finalmente, main.dart es el punto de entrada. Aqui cargamos las variables de entorno con dotenv.load, y luego ejecutamos la app."

**[SEÑALAR el MaterialApp.router]**

**DECIR:**
> "Usamos MaterialApp.router para conectar el router que configuramos. Aplicamos el tema global y conectamos el routerConfig con nuestro AppRouter.router."

**DECIR:**
> "Y eso es todo. Cuando ejecutamos flutter run, este archivo se ejecuta primero, carga el .env, y arranca toda la aplicacion."

---

### 🎯 SECCION 5: CIERRE (1 minuto)

**[PANTALLA: Volver a mostrar la app corriendo]**

**DECIR:**
> "Para resumir, esta aplicacion demuestra varias buenas practicas de desarrollo en Flutter:"

**DECIR:**
> "Uno: Arquitectura MVC por capas que separa responsabilidades y hace el codigo mantenible."

> "Dos: Consumo de API REST con manejo completo de estados: loading, success, error, y empty."

> "Tres: Navegacion declarativa con go_router usando context.push y context.pop."

> "Cuatro: Componentes reutilizables que evitan duplicacion de codigo."

> "Cinco: Variables de entorno para configuracion externa."

> "Y seis: Tema personalizado consistente basado en los colores de la bandera de Colombia."

**[PANTALLA: Mostrar rapidamente la estructura de carpetas una vez mas]**

**DECIR:**
> "El proyecto tiene 24 archivos organizados en seis carpetas: models, services, views, widgets, routes, y themes. En total aproximadamente tres mil lineas de codigo."

**DECIR:**
> "Los paquetes principales que use fueron: http para las peticiones, go_router para navegacion, y flutter_dotenv para variables de entorno."

**[PANTALLA: Tu cara o pantalla final]**

**DECIR:**
> "Espero que este video les haya sido util para entender como consumir una API en Flutter con buena arquitectura. Si tienen preguntas, dejenlas en los comentarios. Gracias por ver!"

---

## 📋 CHECKLIST ANTES DE GRABAR

### Preparacion Tecnica
- [ ] Emulador corriendo y funcionando
- [ ] App instalada y probada
- [ ] VS Code abierto con el proyecto
- [ ] Archivo .env configurado
- [ ] Conexion a internet activa (para API)
- [ ] Grabador de pantalla configurado
- [ ] Microfono funcionando
- [ ] Cerrar notificaciones del sistema

### Preparacion del Proyecto
- [ ] Codigo limpio y formateado
- [ ] Sin errores en el terminal
- [ ] Sin warnings molestos
- [ ] Dashboard cargando correctamente
- [ ] Todas las secciones funcionando
- [ ] Pull-to-refresh funcionando
- [ ] Navegacion fluida

### Archivos a Mostrar (en orden)
1. `lib/parcial_de_prueba/` (estructura)
2. `models/department.dart`
3. `services/department_service.dart`
4. `views/departments_list_view.dart`
5. `views/department_detail_view.dart`
6. `widgets/loading_widget.dart`
7. `widgets/error_widget.dart`
8. `widgets/dashboard_card.dart`
9. `routes/app_router.dart`
10. `main.dart`

---

## 🎬 TIPS DE GRABACION

### Audio
- Habla claro y a ritmo moderado
- Practica el guion antes de grabar
- Usa un microfono decente (no el del laptop si es posible)
- Graba en un lugar silencioso
- Puedes editar pausas largas despues

### Video
- Resolucion minima: 1080p
- FPS: 30 o 60
- Usa zoom para codigo importante
- Mueve el mouse para señalar cosas
- No muevas la ventana muy rapido

### Edicion
- Quita errores y pausas muy largas
- Agrega intro/outro si quieres
- Pon timestamps en la descripcion
- Agrega subtitulos si es posible

### Publicacion
- Titulo claro: "Como consumir API REST en Flutter - Arquitectura MVC"
- Descripcion con timestamps
- Tags: flutter, dart, api, rest, mvc, tutorial
- Miniatura llamativa

---

## ⏱️ TIMESTAMPS SUGERIDOS PARA LA DESCRIPCION

```
0:00 - Introduccion
1:00 - Demostracion de la App
3:00 - Arquitectura del Proyecto
5:00 - Codigo Detallado - Models
5:45 - Codigo Detallado - Services
6:45 - Codigo Detallado - Views
8:15 - Codigo Detallado - Widgets
9:00 - Codigo Detallado - Routes
9:45 - Main.dart
10:15 - Resumen y Cierre
```

---

## 💡 VARIACIONES DEL GUION

### Version Corta (5 minutos)
- Reduce la demo a 1 minuto
- Muestra solo 1 modelo y 1 servicio
- Muestra solo 1 vista
- Salta widgets
- Resume al final

### Version Larga (15 minutos)
- Demo mas profunda de cada seccion
- Muestra todos los modelos
- Explica fromJson y toJson
- Muestra manejo de errores en detalle
- Explica el tema completo
- Habla de buenas practicas

### Version Intermedia (Este guion - 8-10 minutos)
- Balance entre detalle y brevedad
- Muestra lo mas importante
- Explica conceptos clave
- Mantiene atencion del espectador

---

## 📝 NOTAS ADICIONALES

### Puntos Clave a Enfatizar
1. **Arquitectura por capas** - Separacion de responsabilidades
2. **Manejo de estados** - Loading, success, error, empty
3. **Navegacion moderna** - go_router vs Navigator clasico
4. **Reutilizacion** - Widgets y servicios compartidos
5. **Buenas practicas** - .env, try-catch, validaciones

### Errores Comunes a Evitar
- No hablar demasiado rapido
- No asumir conocimientos previos
- No saltarse la demostracion visual
- No hacer el video muy largo
- No olvidar cerrar notificaciones

### Mejoras Opcionales
- Agregar animaciones o transiciones
- Mostrar las peticiones en Postman
- Explicar el .env mas a fondo
- Mostrar como agregar un nuevo endpoint
- Demo de como manejar errores de red

---

## 🎓 GUION ALTERNATIVO PARA PRESENTACION EN CLASE

Si vas a presentar en clase, ajusta el guion:

**Inicio:**
> "Buenos dias profesor/compañeros. Voy a presentar mi proyecto de Flutter que consume la API Colombia..."

**Durante la demo:**
- Interactua mas (pregunta si se ve bien)
- Explica mas despacio
- Pausea para preguntas

**Cierre:**
> "Eso es todo profesor. ¿Tienen alguna pregunta?"

---

*Guion creado para facilitar la explicacion del proyecto API Colombia en formato video*
