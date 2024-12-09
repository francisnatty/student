import 'package:student_centric_app/core/api/api.dart';

abstract class ApiClient {
  Future<ApiResponse<T>> request<T>({
    required String path,
    required MethodType method,
    Map<String, dynamic>? payload,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? rawData,
    T Function(Map<String, dynamic> json)? fromJsonT,
    bool? showLoader,
  });

  void setToken(String token);
  void removeToken();

  String handleException(Exception exception);
}
