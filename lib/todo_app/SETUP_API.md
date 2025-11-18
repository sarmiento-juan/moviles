# 🛠️ Configuración API - JSON Server

## Opción 1: JSON Server (Recomendado para desarrollo)

### Instalación
```bash
npm install -g json-server
```

### Crear archivo db.json
Crear archivo `db.json` en la raíz del proyecto:
```json
{
  "tasks": [
    {
      "id": "1704067800000_1234",
      "title": "Completar proyecto Flutter",
      "completed": false,
      "updatedAt": "2024-01-01T10:00:00Z"
    },
    {
      "id": "1704067800000_5678",
      "title": "Revisar documentación",
      "completed": true,
      "updatedAt": "2024-01-01T11:00:00Z"
    },
    {
      "id": "1704067800000_9012",
      "title": "Escribir tests",
      "completed": false,
      "updatedAt": "2024-01-01T12:00:00Z"
    }
  ]
}
```

### Ejecutar servidor
```bash
json-server --watch db.json --port 3000
```

**Output esperado:**
```
  ⌨️  Press CTRL-C to stop
  ⌨️  Watching for file changes...
  
  Loading db.json
  Serving on http://localhost:3000
```

### Pruebas rápidas
```bash
# Obtener todas
curl http://localhost:3000/tasks

# Crear
curl -X POST http://localhost:3000/tasks \
  -H "Content-Type: application/json" \
  -d '{"id":"nueva","title":"Tarea","completed":false,"updatedAt":"2024-01-01T00:00:00Z"}'

# Actualizar
curl -X PUT http://localhost:3000/tasks/1704067800000_1234 \
  -H "Content-Type: application/json" \
  -d '{"title":"Actualizada","completed":true}'

# Eliminar
curl -X DELETE http://localhost:3000/tasks/1704067800000_1234
```

---

## Opción 2: Node.js Express

Crear `server.js`:
```javascript
const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

let tasks = [
  { id: '1', title: 'Tarea 1', completed: false, updatedAt: new Date().toISOString() }
];

// GET all
app.get('/tasks', (req, res) => res.json(tasks));

// GET one
app.get('/tasks/:id', (req, res) => {
  const task = tasks.find(t => t.id === req.params.id);
  if (!task) return res.status(404).json({ error: 'Not found' });
  res.json(task);
});

// POST create
app.post('/tasks', (req, res) => {
  const newTask = { ...req.body, updatedAt: new Date().toISOString() };
  tasks.push(newTask);
  res.status(201).json(newTask);
});

// PUT update
app.put('/tasks/:id', (req, res) => {
  const task = tasks.find(t => t.id === req.params.id);
  if (!task) return res.status(404).json({ error: 'Not found' });
  Object.assign(task, req.body, { updatedAt: new Date().toISOString() });
  res.json(task);
});

// DELETE
app.delete('/tasks/:id', (req, res) => {
  tasks = tasks.filter(t => t.id !== req.params.id);
  res.status(204).send();
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server on port ${PORT}`));
```

Ejecutar:
```bash
npm install express cors
node server.js
```

---

## Opción 3: Otras APIs

### Python FastAPI
```bash
pip install fastapi uvicorn
# Crear main.py con endpoints CRUD
uvicorn main:app --reload --port 3000
```

### .NET
```bash
dotnet new webapi
dotnet run
```

### Laravel
```bash
composer create-project laravel/laravel todo-api
php artisan tinker
```

---

## Configuración en Flutter

Actualizar `lib/todo_app/main.dart`:
```dart
TaskRemoteDataSource(
  baseUrl: 'http://localhost:3000',  // Cambiar según tu setup
)
```

---

## Troubleshooting

| Error | Solución |
|-------|----------|
| CORS error | Activar CORS en servidor |
| Connection refused | Verificar puerto 3000, reiniciar servidor |
| JSON inválido | Validar formato en db.json |
| No autorizado (401) | Implementar auth si es necesario |

---

## Testing con Postman

1. Importar requests en Postman
2. Variable: `{{base_url}}` = `http://localhost:3000`
3. Headers: `Content-Type: application/json`
4. Headers: `Idempotency-Key: unique-value`

---

**Recomendación:** Usar JSON Server para desarrollo rápido, Express para más control.
