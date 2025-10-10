/// Modelo para representar una broma de Chuck Norris
/// Estructura basada en la respuesta de la API
class Joke {
  final String id;
  final String value;
  final String iconUrl;
  final String url;
  final List<String> categories;
  final String createdAt;
  final String updatedAt;

  Joke({
    required this.id,
    required this.value,
    required this.iconUrl,
    required this.url,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crea una instancia de Joke desde un JSON
  /// Ejemplo de respuesta de la API:
  /// ```json
  /// {
  ///   "id": "SR9ceDDCQX2Wc5uEHtYGPA",
  ///   "value": "Chuck Norris jumped out of the fire...",
  ///   "icon_url": "...",
  ///   "url": "...",
  ///   "categories": [],
  ///   "created_at": "2020-01-05 13:42:24.142371",
  ///   "updated_at": "2020-01-05 13:42:24.142371"
  /// }
  /// ```
  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'] ?? '',
      value: json['value'] ?? 'No joke available',
      iconUrl: json['icon_url'] ?? '',
      url: json['url'] ?? '',
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'icon_url': iconUrl,
      'url': url,
      'categories': categories,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Verifica si la broma tiene categorias
  bool get hasCategories => categories.isNotEmpty;

  /// Obtiene un texto formateado de las categorias
  String get categoriesText => categories.join(', ').toUpperCase();
}
