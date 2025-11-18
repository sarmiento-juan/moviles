/// Modelo de datos para una tarea
class Task {
  final String id;
  final String title;
  final bool completed;
  final DateTime updatedAt;
  final bool deleted;

  Task({
    required this.id,
    required this.title,
    required this.completed,
    required this.updatedAt,
    this.deleted = false,
  });

  /// Convertir de JSON a Task
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      completed: json['completed'] ?? false,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      deleted: json['deleted'] ?? false,
    );
  }

  /// Convertir de Task a JSON (para enviar a API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'updatedAt': updatedAt.toIso8601String(),
      'deleted': deleted,
    };
  }

  /// Convertir a Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed ? 1 : 0,
      'updated_at': updatedAt.toIso8601String(),
      'deleted': deleted ? 1 : 0,
    };
  }

  /// Crear Task desde Map de SQLite
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      completed: (map['completed'] ?? 0) == 1,
      updatedAt: DateTime.parse(
        map['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      deleted: (map['deleted'] ?? 0) == 1,
    );
  }

  /// Copiar con cambios (patrón copyWith)
  Task copyWith({
    String? id,
    String? title,
    bool? completed,
    DateTime? updatedAt,
    bool? deleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  /// Comparar tareas por updatedAt (para manejo de conflictos LWW)
  int compareByTimestamp(Task other) {
    return updatedAt.compareTo(other.updatedAt);
  }

  @override
  String toString() =>
      'Task(id: $id, title: $title, completed: $completed, updatedAt: $updatedAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          completed == other.completed &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ completed.hashCode ^ updatedAt.hashCode;
}
