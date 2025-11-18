// Model for TouristicAttraction endpoint
class TouristicAttraction {
  final int id;
  final String name;
  final String description;
  final List<String> images;
  final String? latitude;
  final String? longitude;
  final int? cityId;

  TouristicAttraction({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    this.latitude,
    this.longitude,
    this.cityId,
  });

  factory TouristicAttraction.fromJson(Map<String, dynamic> json) {
    return TouristicAttraction(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      cityId: json['cityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'cityId': cityId,
    };
  }

  String get mainImage => images.isNotEmpty ? images.first : '';
  bool get hasImages => images.isNotEmpty;
  String get coordinates => latitude != null && longitude != null
      ? 'Lat: $latitude, Lon: $longitude'
      : 'Sin coordenadas';
}
