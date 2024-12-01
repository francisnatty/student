// lib/features/auth/providers/basic_information_provider.dart

import 'package:flutter/material.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/network/api_service.dart';
import 'package:student_centric_app/core/storage/secure_store.dart';
import 'package:student_centric_app/features/auth/models/country_model.dart';
import 'package:student_centric_app/features/auth/models/school_model.dart';
import 'package:student_centric_app/features/auth/screens/upload_profile_picture_screen.dart';

class BasicInformationProvider with ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPage = 0;

  // Loading and error states for basic information submission
  bool _isLoading = false;
  String? _errorMessage;

  // Countries data
  List<Country> _countries = [];
  bool _isCountriesLoading = false;
  String? _countriesError;

  // Cities data
  List<States> _cities = [];
  bool _isCitiesLoading = false;
  String? _citiesError;

  // New Data
  List<School> _schools = [];
  bool _isSchoolsLoading = false;
  String? _schoolsError;

  List<ProgramType> _programTypes = [];
  bool _isProgramTypesLoading = false;
  String? _programTypesError;

  List<Course> _courses = [];
  bool _isCoursesLoading = false;
  String? _coursesError;

  List<Year> _years = [];
  bool _isYearsLoading = false;
  String? _yearsError;

  // Selected IDs
  int? _selectedSchoolId;
  int? _selectedProgramTypeId;
  int? _selectedCourseId;
  int? _selectedYearId;

  // Getters
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Country> get countries => _countries;
  bool get isCountriesLoading => _isCountriesLoading;
  String? get countriesError => _countriesError;

  List<States> get cities => _cities;
  bool get isCitiesLoading => _isCitiesLoading;
  String? get citiesError => _citiesError;

  List<School> get schools => _schools;
  bool get isSchoolsLoading => _isSchoolsLoading;
  String? get schoolsError => _schoolsError;

  List<ProgramType> get programTypes => _programTypes;
  bool get isProgramTypesLoading => _isProgramTypesLoading;
  String? get programTypesError => _programTypesError;

  List<Course> get courses => _courses;
  bool get isCoursesLoading => _isCoursesLoading;
  String? get coursesError => _coursesError;

  List<Year> get years => _years;
  bool get isYearsLoading => _isYearsLoading;
  String? get yearsError => _yearsError;

  int? get selectedSchoolId => _selectedSchoolId;
  int? get selectedProgramTypeId => _selectedProgramTypeId;
  int? get selectedCourseId => _selectedCourseId;
  int? get selectedYearId => _selectedYearId;

  BasicInformationProvider() {
    fetchCountries();
    // We will fetch schools when the school details screen is initialized
  }

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < 3) {
      _currentPage++;
      pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  /// Fetch Countries
  Future<void> fetchCountries() async {
    _isCountriesLoading = true;
    _countriesError = null;
    notifyListeners();

    try {
      final response = await ApiService.instance.get('/datas/fetch/countries');

      if (response != null && response.statusCode == 200) {
        final data = response.data['data'] as List;
        _countries = data.map((json) => Country.fromJson(json)).toList();
      } else {
        _countriesError = response?.data['msg'] ?? 'Failed to fetch countries.';
      }
    } catch (e) {
      _countriesError = 'An error occurred while fetching countries.';
    } finally {
      _isCountriesLoading = false;
      notifyListeners();
    }
  }

  /// Fetch Cities based on Country ID
  Future<void> fetchCities({required Country selectedCountry}) async {
    //_isCitiesLoading = true;
    _citiesError = null;
    _cities = selectedCountry.states??[];
    debugPrint("cities is ==> ${_cities.first.name}");
    notifyListeners();

    // try {
    //   final response = await ApiService.instance
    //       .get('/datas/fetch/citiesPerCountry/$countryId');
    //
    //   if (response != null && response.statusCode == 200) {
    //     final data = response.data['data'] as List;
    //     _cities = data.map((json) => States.fromJson(json)).toList();
    //   } else {
    //     _citiesError = response?.data['msg'] ?? 'Failed to fetch cities.';
    //   }
    // } catch (e) {
    //   _citiesError = 'An error occurred while fetching cities.';
    // } finally {
    //   _isCitiesLoading = false;
    //   notifyListeners();
    // }
  }

  /// Fetch Schools
  Future<void> fetchSchools() async {
    _isSchoolsLoading = true;
    _schoolsError = null;
    // notifyListeners();

    try {
      final response = await ApiService.instance.get('/datas/fetch/schools');

      if (response != null && response.statusCode == 200) {
        final data = response.data['data'] as List;
        _schools = data.map((json) => School.fromJson(json)).toList();
      } else {
        _schoolsError = response?.data['msg'] ?? 'Failed to fetch schools.';
      }
    } catch (e) {
      _schoolsError = 'An error occurred while fetching schools.';
    } finally {
      _isSchoolsLoading = false;
      notifyListeners();
    }
  }

  /// Fetch Program Types based on School ID
  Future<void> fetchProgramTypes(int schoolId) async {
    _isProgramTypesLoading = true;
    _programTypesError = null;
    _programTypes = [];
    notifyListeners();

    try {
      final response = await ApiService.instance
          .get('/datas/fetch/program-types');

      if (response != null && response.statusCode == 200) {
        final data = response.data['data'] as List;
        _programTypes = data.map((json) => ProgramType.fromJson(json)).toList();
      } else {
        _programTypesError =
            response?.data['msg'] ?? 'Failed to fetch program types.';
      }
    } catch (e) {
      _programTypesError = 'An error occurred while fetching program types.';
    } finally {
      _isProgramTypesLoading = false;
      notifyListeners();
    }
  }

  /// Fetch Courses based on School ID and Program Type ID
  Future<void> fetchCourses(int schoolId, int programTypeId) async {
    _isCoursesLoading = true;
    _coursesError = null;
    _courses = [];
    notifyListeners();

    try {
      final response = await ApiService.instance.get(
          '/datas/fetch/schools/courses');

      if (response != null && response.statusCode == 200) {
        final data = response.data['data'] as List;
        _courses = data.map((json) => Course.fromJson(json)).toList();
      } else {
        _coursesError = response?.data['msg'] ?? 'Failed to fetch courses.';
      }
    } catch (e) {
      _coursesError = 'An error occurred while fetching courses.';
    } finally {
      _isCoursesLoading = false;
      notifyListeners();
    }
  }

  /// Fetch Years
  Future<void> fetchYears() async {
    _isYearsLoading = true;
    _yearsError = null;
    _years = [];
    notifyListeners();

    try {
      final response = await ApiService.instance.get('/datas/years');

      if (response != null && response.statusCode == 200) {
        final data = response.data['data'] as List;
        _years = data.map((json) => Year.fromJson(json)).toList();
      } else {
        _yearsError = response?.data['msg'] ?? 'Failed to fetch years.';
      }
    } catch (e) {
      _yearsError = 'An error occurred while fetching years.';
    } finally {
      _isYearsLoading = false;
      notifyListeners();
    }
  }

  // Setters for selected IDs
  void setSelectedSchoolId(int id) {
    _selectedSchoolId = id;
    notifyListeners();
  }

  void setSelectedProgramTypeId(int id) {
    _selectedProgramTypeId = id;
    notifyListeners();
  }

  void setSelectedCourseId(int id) {
    _selectedCourseId = id;
    notifyListeners();
  }

  void setSelectedYearId(int id) {
    _selectedYearId = id;
    notifyListeners();
  }

  // Reset selections based on dependency
  void resetSelections({required String from}) {
    if (from == 'school') {
      _selectedProgramTypeId = null;
      _programTypes = [];
      _selectedCourseId = null;
      _courses = [];
      _selectedYearId = null;
      _years = [];
    } else if (from == 'programType') {
      _selectedCourseId = null;
      _courses = [];
      _selectedYearId = null;
      _years = [];
    } else if (from == 'course') {
      _selectedYearId = null;
      _years = [];
    }
    notifyListeners();
  }

  /// Method to submit basic information
  Future<void> submitBasicInformation({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required bool confirmSexAtBirth,
    required String dob,
    required String ethnicity,
    required String religion,
    required String maritalStatus,
    required BuildContext context,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final storage = SecureStorage();

    await storage.write(key: 'email', value: email);

    final data = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "gender": gender,
      "confirm_sex_at_birth": confirmSexAtBirth ? 1 : 0,
      "dob": dob,
      "ethnicity": ethnicity,
      "religious": religion,
      "marital_status": maritalStatus,
    };

    try {
      final response = await ApiService.instance.patch(
        "/auth/onboarding/user/basicInformation",
        data: data,
        showBanner: true,
      );

      if (response != null && response.statusCode == 200) {
        nextPage();
      } else {
        _errorMessage = response?.data['message'] ?? 'An error occurred.';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to submit information. Please try again.';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Submit School Information
  Future<void> submitSchoolInformation({
    required String schoolName,
    required String programType,
    required String courseOfStudy,
    required String yearInSchool,
    required BuildContext context,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final storage = SecureStorage();
    String? email = await storage.get(key: 'email');

    if (email == null) {
      _errorMessage = 'Email not found. Please try again.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final data = {
      "email": email,
      "school_name": schoolName,
      "course_of_study": courseOfStudy,
      "Program_type": programType,
      "year_in_school": yearInSchool,
    };

    try {
      final response = await ApiService.instance.patch(
        "/auth/onboarding/user/update/school",
        data: data,
        showBanner: true,
      );

      if (response != null && response.statusCode == 200) {
        nextPage();
      } else {
        _errorMessage = response?.data['message'] ?? 'An error occurred.';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to submit school information. Please try again.';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to submit occupation information
  Future<void> submitOccupationInformation({
    required String industry,
    required String specialty,
    required String jobTitle,
    required BuildContext context,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final storage = SecureStorage();
    String? email = await storage.get(key: 'email');

    if (email == null) {
      _errorMessage = 'Email not found. Please try again.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final data = {
      "email": email,
      "industry": industry,
      "specialty": specialty,
      "job_title": jobTitle,
      "program_type": jobTitle, // Assuming program_type is jobTitle here
    };

    try {
      final response = await ApiService.instance.patch(
        "/auth/onboarding/user/update/occupation",
        data: data,
        showBanner: true,
      );

      if (response != null && response.statusCode == 200) {
        // Handle success, e.g., navigate to the next screen
        context.push(UploadProfilePictureScreen());
      } else {
        _errorMessage = response?.data['message'] ?? 'An error occurred.';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage =
          'Failed to submit occupation information. Please try again.';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
