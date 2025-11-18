// Model for President endpoint
class President {
  final int id;
  final String name;
  final String lastName;
  final String? startPeriodDate;
  final String? endPeriodDate;
  final String? politicalParty;
  final String? description;
  final String? image;
  final int? cityId;

  President({
    required this.id,
    required this.name,
    required this.lastName,
    this.startPeriodDate,
    this.endPeriodDate,
    this.politicalParty,
    this.description,
    this.image,
    this.cityId,
  });

  factory President.fromJson(Map<String, dynamic> json) {
    return President(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      startPeriodDate: json['startPeriodDate']?.toString(),
      endPeriodDate: json['endPeriodDate']?.toString(),
      politicalParty: json['politicalParty']?.toString(),
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      cityId: json['cityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'startPeriodDate': startPeriodDate,
      'endPeriodDate': endPeriodDate,
      'politicalParty': politicalParty,
      'description': description,
      'image': image,
      'cityId': cityId,
    };
  }

  String get fullName => '$name $lastName';
  String get period =>
      '${startPeriodDate ?? 'N/A'} - ${endPeriodDate ?? 'N/A'}';
}
