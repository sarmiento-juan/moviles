// Model for Department endpoint
class Department {
  final int id;
  final String name;
  final String description;
  final String? cityCapitalId;
  final int municipalities;
  final String surface;
  final int population;
  final String? phonePrefix;
  final int? regionId;

  Department({
    required this.id,
    required this.name,
    required this.description,
    this.cityCapitalId,
    required this.municipalities,
    required this.surface,
    required this.population,
    this.phonePrefix,
    this.regionId,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      cityCapitalId: json['cityCapitalId']?.toString(),
      municipalities: json['municipalities'] ?? 0,
      surface: json['surface']?.toString() ?? '0',
      population: json['population'] ?? 0,
      phonePrefix: json['phonePrefix']?.toString(),
      regionId: json['regionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cityCapitalId': cityCapitalId,
      'municipalities': municipalities,
      'surface': surface,
      'population': population,
      'phonePrefix': phonePrefix,
      'regionId': regionId,
    };
  }
}
