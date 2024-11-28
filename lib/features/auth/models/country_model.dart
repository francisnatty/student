// lib/models/country_model.dart

class Country {
  final int id;
  final String countryName;
  final int status;
  final String? createdAt;
  final String? updatedAt;

  Country({
    required this.id,
    required this.countryName,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      countryName: json['countryName'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

// lib/models/city_model.dart

class City {
  final int id;
  final int countryId;
  final String cityName;
  final int status;
  final String? createdAt;
  final String? updatedAt;

  City({
    required this.id,
    required this.countryId,
    required this.cityName,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      countryId: json['country_id'],
      cityName: json['cityName'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
