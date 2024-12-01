// lib/models/country_model.dart


class Country {
  String? code2;
  String? code3;
  String? name;
  String? capital;
  String? region;
  String? subregion;
  List<States>? states;

  Country(
      {this.code2,
        this.code3,
        this.name,
        this.capital,
        this.region,
        this.subregion,
        this.states});

  Country.fromJson(Map<String, dynamic> json) {
    code2 = json['code2'];
    code3 = json['code3'];
    name = json['name'];
    capital = json['capital'];
    region = json['region'];
    subregion = json['subregion'];
    if (json['states'] != null) {
      states = <States>[];
      json['states'].forEach((v) {
        states!.add(States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code2'] = code2;
    data['code3'] = code3;
    data['name'] = name;
    data['capital'] = capital;
    data['region'] = region;
    data['subregion'] = subregion;
    if (states != null) {
      data['states'] = states!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  String? code;
  String? name;
  //Null? subdivision;

  States({this.code, this.name,});

  States.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    //subdivision = json['subdivision'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    //data['subdivision'] = subdivision;
    return data;
  }
}





// class Country {
//   final int id;
//   final String countryName;
//   final int status;
//   final String? createdAt;
//   final String? updatedAt;
//
//   Country({
//     required this.id,
//     required this.countryName,
//     required this.status,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory Country.fromJson(Map<String, dynamic> json) {
//     return Country(
//       id: json['id'],
//       countryName: json['countryName'],
//       status: json['status'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//     );
//   }
// }

// lib/models/city_model.dart

// class City {
//   final int id;
//   final int countryId;
//   final String cityName;
//   final int status;
//   final String? createdAt;
//   final String? updatedAt;
//
//   City({
//     required this.id,
//     required this.countryId,
//     required this.cityName,
//     required this.status,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory City.fromJson(Map<String, dynamic> json) {
//     return City(
//       id: json['id'],
//       countryId: json['country_id'],
//       cityName: json['cityName'],
//       status: json['status'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//     );
//   }
// }
