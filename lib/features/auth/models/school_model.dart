// lib/features/auth/models/school_model.dart

class School {
  final int id;
  final String schoolName;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  School({
    required this.id,
    required this.schoolName,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      schoolName: json['schoolName'],
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}

class ProgramType {
  final int id;
  final int schoolId;
  final String name;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProgramType({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProgramType.fromJson(Map<String, dynamic> json) {
    return ProgramType(
      id: json['id'],
      schoolId: json['school_id'],
      name: json['name'],
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}

class Course {
  final int id;
  //final int programTypeId;
  //final int schoolId;
  final String courseName;
  final int status;
  //final DateTime? createdAt;
  //final DateTime? updatedAt;

  Course({
    required this.id,
    //required this.programTypeId,
    //required this.schoolId,
    required this.courseName,
    required this.status,
    // this.createdAt,
    // this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      //programTypeId: json['programType_id'],
      //schoolId: json['school_id'],
      courseName: json['courseName'],
      status: json['status'],
      // createdAt: json['created_at'] != null
      //     ? DateTime.parse(json['created_at'])
      //     : null,
      // updatedAt: json['updated_at'] != null
      //     ? DateTime.parse(json['updated_at'])
      //     : null,
    );
  }
}

class Year {
  final int id;
  final int courseId;
  final String name;
  final int status;
  //final DateTime? createdAt;
  //final DateTime? updatedAt;

  Year({
    required this.id,
    required this.courseId,
    required this.name,
    required this.status,
   // this.createdAt,
    //this.updatedAt,
  });

  factory Year.fromJson(Map<String, dynamic> json) {
    return Year(
      id: json['id'],
      courseId: json['course_id'],
      name: json['name'],
      status: json['status'],
      // createdAt: json['created_at'] != null
      //     ? DateTime.parse(json['created_at'])
      //     : null,
      // updatedAt: json['updated_at'] != null
      //     ? DateTime.parse(json['updated_at'])
      //     : null,
    );
  }
}
