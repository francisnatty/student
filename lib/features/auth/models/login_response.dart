class LoginResponse {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;

  LoginResponse({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
  });

  // Factory constructor to create a User object from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
    );
  }

  // Method to convert a User object into JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
    };
  }
}
