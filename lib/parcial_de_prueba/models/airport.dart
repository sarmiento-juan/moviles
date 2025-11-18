// Model for Airport endpoint
class Airport {
  final int id;
  final String name;
  final String? oaciCode;
  final String? iataCode;
  final String type;
  final int? departmentId;
  final int? cityId;
  final String? latitude;
  final String? longitude;

  Airport({
    required this.id,
    required this.name,
    this.oaciCode,
    this.iataCode,
    required this.type,
    this.departmentId,
    this.cityId,
    this.latitude,
    this.longitude,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      oaciCode: json['oaciCode']?.toString(),
      iataCode: json['iataCode']?.toString(),
      type: json['type'] ?? '',
      departmentId: json['departmentId'],
      cityId: json['cityId'],
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'oaciCode': oaciCode,
      'iataCode': iataCode,
      'type': type,
      'departmentId': departmentId,
      'cityId': cityId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get codes => 'OACI: ${oaciCode ?? 'N/A'} | IATA: ${iataCode ?? 'N/A'}';
  String get coordinates => latitude != null && longitude != null
      ? 'Lat: $latitude, Lon: $longitude'
      : 'Sin coordenadas';
}
