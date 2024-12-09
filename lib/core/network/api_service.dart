import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode

typedef OnSuccess = void Function(String message);
typedef OnError = void Function(String message);

class ApiService {
  // Singleton pattern
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  late Dio _dio;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // No method calls in logs
      errorMethodCount: 0,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  // Optional callbacks for success and error messages
  OnSuccess? onSuccess;
  OnError? onError;

  // Initialize Dio
  void init({String baseUrl = '', Map<String, String>? headers}) {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    );

    _dio = Dio(options);

    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _logRequest(options);
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logResponse(response);
        _processResponse(response);
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        debugPrint("error here => ${error.toString()}");
        _logError(error);
        _processError(error);
        return handler.next(error);
      },
    ));
  }

  // Method to set success and error callbacks
  void setCallbacks({OnSuccess? onSuccess, OnError? onError}) {
    this.onSuccess = onSuccess;
    this.onError = onError;
  }

  // Generic GET request
  Future<Response?> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool isProtected = false,
    bool showBanner = false,
  }) async {
    try {
      Options options = Options();
      if (isProtected) {
        options.headers = await _getAuthHeaders();
      }

      // Pass showBanner via options.extra
      options.extra = {'showBanner': showBanner};

      Response response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on DioException {
      // Error handling is managed in interceptors
      return null;
    }
  }

  // Generic POST request
  Future<Response?> post(
      String path, {
        dynamic data,
        bool isProtected = false,
        bool isMultipart = false,
        bool showBanner = true,
      }) async {
    try {
      Options options = Options();
      if (isProtected) {
        options.headers = await _getAuthHeaders();
      }
      if (isMultipart) {
        options.contentType = 'multipart/form-data';
      }

      // Pass showBanner via options.extra
      options.extra = {'showBanner': showBanner};

      // Avoid wrapping FormData again
      final requestData = isMultipart && data is! FormData
          ? FormData.fromMap(data)
          : data;

      Response response = await _dio.post(
        path,
        data: requestData,
        options: options,
      );

      return response;
    } on DioException {
      // Error handling is managed in interceptors
      return null;
    }
  }


  // Generic PATCH request
  Future<Response?> patch(
    String path, {
    dynamic data,
    bool isProtected = false,
    bool isMultipart = false,
    bool showBanner = true,
  }) async {
    try {
      Options options = Options();
      if (isProtected) {
        options.headers = await _getAuthHeaders();
      }
      if (isMultipart) {
        options.contentType = 'multipart/form-data';
      }

      // Pass showBanner via options.extra
      options.extra = {'showBanner': showBanner};

      Response response = await _dio.patch(
        path,
        data: isMultipart ? FormData.fromMap(data) : data,
        options: options,
      );

      return response;
    } on DioException {
      // Error handling is managed in interceptors
      return null;
    }
  }

  // **Updated PUT method with form data support**
  Future<Response?> put(
    String path, {
    dynamic data,
    bool isProtected = false,
    bool isMultipart = false,
    bool showBanner = false,
  }) async {
    try {
      Options options = Options();
      if (isProtected) {
        options.headers = await _getAuthHeaders();
      }
      if (isMultipart) {
        options.contentType = 'multipart/form-data';
      }

      // Pass showBanner via options.extra
      options.extra = {'showBanner': showBanner};

      Response response = await _dio.put(
        path,
        data: isMultipart ? FormData.fromMap(data) : data,
        options: options,
      );

      return response;
    } on DioException {
      // Error handling is managed in interceptors
      return null;
    }
  }

  // Generic DELETE request
  Future<Response?> delete(
    String path, {
    dynamic data,
    bool isProtected = false,
    bool isMultipart = false, // Optional, in case you need it
    bool showBanner = false,
  }) async {
    try {
      Options options = Options();
      if (isProtected) {
        options.headers = await _getAuthHeaders();
      }
      if (isMultipart) {
        options.contentType = 'multipart/form-data';
      }

      // Pass showBanner via options.extra
      options.extra = {'showBanner': showBanner};

      Response response = await _dio.delete(
        path,
        data: isMultipart ? FormData.fromMap(data) : data,
        options: options,
      );

      return response;
    } on DioException {
      // Error handling is managed in interceptors
      return null;
    }
  }

  // ... rest of your class remained
  // Handle Dio errors
  void _handleDioError(DioException error, bool showBanner) {
    String errorMessage = "An unexpected error occurred";

    if (error.type == DioExceptionType.connectionTimeout) {
      errorMessage = "Connection timed out";
    } else if (error.type == DioExceptionType.receiveTimeout) {
      errorMessage = "Receive timed out";
    } else if (error.type == DioExceptionType.badResponse) {
      errorMessage = error.response?.data['message'] ??
          "Received invalid status code: ${error.response?.statusCode}";
    } else if (error.type == DioExceptionType.cancel) {
      errorMessage = "Request was cancelled";
    } else if (error.type == DioExceptionType.unknown) {
      errorMessage = "No internet connection";
    }

    if (showBanner && onError != null) {
      onError!(errorMessage);
    }
  }

  // Placeholder for getting auth headers
  Future<Map<String, String>> _getAuthHeaders() async {
    // Implement your logic to retrieve the token
    //const FlutterSecureStorage _storage = FlutterSecureStorage();
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    debugPrint("token is : $token");

    return {
      'Authorization': 'Bearer $token',
    };
  }

  // Logging Methods
  void _logRequest(RequestOptions options) {
    if (kDebugMode) {
      _logger.i("===== API Request =====");
      _logger.i("Method: ${options.method}");
      _logger.i("URL: ${options.uri}");
      if (options.headers.isNotEmpty) {
        // Mask Authorization Header
        var headers = Map<String, dynamic>.from(options.headers);
        if (headers.containsKey('Authorization')) {
          headers['Authorization'] = 'Bearer ***';
        }
        _logger.i("Headers: $headers");
      }
      if (options.queryParameters.isNotEmpty) {
        _logger.i("Query Parameters: ${options.queryParameters}");
      }
      if (options.data != null) {
        _logger.i("Body: ${_formatJson(options.data)}");
      }
      _logger.i("=======================\n");
    }
  }

  void _logResponse(Response response) {
    if (kDebugMode) {
      _logger.i("===== API Response =====");
      _logger.i("URL: ${response.requestOptions.uri}");
      _logger.i("Status Code: ${response.statusCode}");
      _logger.i("Data: ${_formatJson(response.data)}");
      _logger.i("========================\n");
    }
  }

  void _logError(DioException error) {
    if (kDebugMode) {
      _logger.e("===== API Error =====");
      if (error.response != null) {
        _logger.e("URL: ${error.requestOptions.uri}");
        _logger.e("Status Code: ${error.response?.statusCode}");
        _logger.e("Data: ${_formatJson(error.response?.data)}");
      } else {
        _logger.e("Error Message: ${error.message}");
      }
      _logger.e("======================\n");
    }
  }

  // Helper method to format JSON
  String _formatJson(dynamic data) {
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  // Process response to determine success or error
  void _processResponse(Response response) {
    bool showBanner = response.requestOptions.extra['showBanner'] ?? false;

    if (showBanner && onSuccess != null) {
      try {
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> data = response.data;

          // Check for 'error' field
          if (data.containsKey('error')) {
            if (data['error'] == false) {
              String message = data['msg'] ?? "Request Successful";
              onSuccess!(message);
            } else {
              String message = data['message'] ?? "An error occurred";
              onError?.call(message);
            }
            return;
          }

          // Check for 'code' and 'message' fields
          if (data.containsKey('code') && data.containsKey('message')) {
            String message = data['message'].toString().isNotEmpty
                ? data['message']
                : "An error occurred";
            onError?.call(message);
            return;
          }
        }

        // Default handling based on status code
        if (response.statusCode != null) {
          if (response.statusCode! >= 200 && response.statusCode! < 300) {
            onSuccess!("Request Successful");
          } else {
            onError?.call("Received status code: ${response.statusCode}");
          }
        } else {
          onError?.call("Unknown response status");
        }
      } catch (e) {
        // In case of any parsing errors, use default messages
        onError?.call("Failed to process the response");
      }
    }
  }

  // Process DioError to trigger onError callback
  void _processError(DioException error) {
    bool showBanner = error.requestOptions.extra['showBanner'] ?? false;

    if (showBanner && onError != null) {
      try {
        if (error.response?.data is Map<String, dynamic>) {
          Map<String, dynamic> data = error.response!.data;

          // Check for 'message' field
          if (data.containsKey('message') &&
              data['message'].toString().isNotEmpty) {
            onError!(data['message']);
            return;
          }
        }

        // Fallback to default error messages based on status code or error type
        String errorMessage = "An unexpected error occurred";

        if (error.type == DioExceptionType.connectionTimeout) {
          errorMessage = "Connection timed out";
        } else if (error.type == DioExceptionType.receiveTimeout) {
          errorMessage = "Receive timed out";
        } else if (error.type == DioExceptionType.badResponse) {
          debugPrint("derey here =>  ${error.response?.data['msg']??''}");
          errorMessage = error.response?.data != null
              ? "${error.response?.data['msg']??''}"
              : "Bad response from server";
        } else if (error.type == DioExceptionType.cancel) {
          errorMessage = "Request was cancelled";
        } else if (error.type == DioExceptionType.unknown) {
          errorMessage = "No internet connection";
        }
        onError!(errorMessage);
      } catch (e) {
        // In case of any parsing errors, use a generic message
        onError!("Failed to process the error");
      }
    }
  }
}
