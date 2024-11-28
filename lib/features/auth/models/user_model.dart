class UserModel {
  final int id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final int confirmSexAtBirth;
  final String? dob;
  final String? ethnicity;
  final String? religious;
  final String? maritalStatus;
  final String? country;
  final String? city;
  final String? street;
  final String? postalCode;
  final String? schoolName;
  final String? courseOfStudy;
  final String? yearInSchool;
  final String? industry;
  final String? specialty;
  final String? jobTitle;
  final String? programType;
  final String? profileImage;
  final String? phoneNumber;
  final int otpCode;
  final String? otpCodeSMS;
  final String? pinId;
  final String otpExpiration;
  final bool isPhoneVerify;
  final bool isEmailVerify;
  final bool isBasicInformationVerify;
  final bool isAddressVerify;
  final bool isSchoolVerify;
  final bool isOccupationVerify;
  final bool isProfileUpload;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.gender,
    required this.confirmSexAtBirth,
    this.dob,
    this.ethnicity,
    this.religious,
    this.maritalStatus,
    this.country,
    this.city,
    this.street,
    this.postalCode,
    this.schoolName,
    this.courseOfStudy,
    this.yearInSchool,
    this.industry,
    this.specialty,
    this.jobTitle,
    this.programType,
    this.profileImage,
    this.phoneNumber,
    required this.otpCode,
    this.otpCodeSMS,
    this.pinId,
    required this.otpExpiration,
    required this.isPhoneVerify,
    required this.isEmailVerify,
    required this.isBasicInformationVerify,
    required this.isAddressVerify,
    required this.isSchoolVerify,
    required this.isOccupationVerify,
    required this.isProfileUpload,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      confirmSexAtBirth: json['confirm_sex_at_birth'],
      dob: json['dob'],
      ethnicity: json['ethnicity'],
      religious: json['religious'],
      maritalStatus: json['marital_status'],
      country: json['country'],
      city: json['city'],
      street: json['street'],
      postalCode: json['postal_code'],
      schoolName: json['school_name'],
      courseOfStudy: json['course_of_study'],
      yearInSchool: json['year_in_school'],
      industry: json['industry'],
      specialty: json['specialty'],
      jobTitle: json['job_title'],
      programType: json['program_type'],
      profileImage: json['profile_image'],
      phoneNumber: json['phone_number'],
      otpCode: json['otp_code'],
      otpCodeSMS: json['otp_code_SMS'],
      pinId: json['pin_id'],
      otpExpiration: json['otp_expiration'],
      isPhoneVerify: json['is_phone_verify'] == 1,
      isEmailVerify: json['is_email_verify'] == 1,
      isBasicInformationVerify: json['is_basic_information_verify'] == 1,
      isAddressVerify: json['is_address_verify'] == 1,
      isSchoolVerify: json['is_school_verify'] == 1,
      isOccupationVerify: json['is_occupation_verify'] == 1,
      isProfileUpload: json['is_profile_upload'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
