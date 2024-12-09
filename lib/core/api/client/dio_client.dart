import 'package:dio/dio.dart';

import '../../utils/debug_logger.dart';
import '../error/custom_error.dart';
import 'api_client.dart';
import '../response/api_response.dart';

enum MethodType { get, post, put, delete, patch }

class DioClient implements ApiClient {
  late Dio _client;
  // late CustomInterceptor _customInterceptor;

  DioClient() {
    _client = Dio()
      ..options.baseUrl = "https://typescript-boilerplate.onrender.com/api/v1/";
    // _customInterceptor = CustomInterceptor(dio: _client);
    // _client.interceptors.add(_customInterceptor);
  }

  @override
  void removeToken() {
    _client.options.headers.remove('Authorization');
  }

  @override
  void setToken(String token) {
    _client.options.headers['Authorization'] = 'Bearer $token';
    _client.options.headers['Content-Type'] = 'application/json';
  }

  @override
  Future<ApiResponse<T>> request<T>({
    required String path,
    required MethodType method,
    Map<String, dynamic>? payload,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? rawData,
    T Function(Map<String, dynamic> json)? fromJsonT,
    bool? showLoader,
  }) async {
    ApiResponse<T> apiResponse;
    Response response;
    try {
      switch (method) {
        case MethodType.get:
          response = await _client.get(
            path,
            data: payload,
            queryParameters: queryParameters,
          );
          // print(response.realUri);
          break;
        case MethodType.post:
          response = await _client.post(
            path,
            data: payload,
            queryParameters: queryParameters,
          );
          break;
        case MethodType.put:
          response = await _client.put(
            path,
            data: payload,
            queryParameters: queryParameters,
          );
          break;
        case MethodType.delete:
          response = await _client.delete(
            path,
            data: payload,
            queryParameters: queryParameters,
          );
          break;
        case MethodType.patch:
          response = await _client.patch(
            path,
            data: payload,
            queryParameters: queryParameters,
          );
          break;
      }

      apiResponse = ApiResponse(
        data: fromJsonT?.call(response.data),
        rawJson: response.data,
        statusCode: response.statusCode.toString(),
        success: true,
      );

      return apiResponse;
    } catch (e) {
      DebugLogger.log('DIO ERROR', e.toString());
      var err = CustomHandlerObject.getError(error: e);
      apiResponse = ApiResponse(
        success: false,
        failure: err,
      );
      return apiResponse;
    }
  }

  @override
  String handleException(Exception exception) {
    throw UnimplementedError();
  }
}
