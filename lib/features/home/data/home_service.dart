import 'package:dio/dio.dart';
import 'package:student_centric_app/core/api/api.dart';
import 'package:student_centric_app/features/home/models/get_status_model.dart';

import '../../../config/service_locator.dart';
import '../../../core/storage/local_storage.dart';

import '../../../core/utils/debug_logger.dart';
import '../models/create_feeds_params.dart';
import '../models/posts_model.dart';

abstract class HomeService {
  Future<ApiResponse<PostModel>> getFeeds();
  Future<ApiResponse<GetStatusModel>> getStatus();
  Future<ApiResponse> createFeed({required CreateFeedsParams params});
}

class HomeServiceImpl extends HomeService {
  final apiClient = Di.getIt<ApiClient>();
  final localStorage = Di.getIt<LocalStorage>();
  Dio dio = Dio();

  @override
  Future<ApiResponse<PostModel>> getFeeds() async {
    String? token = await localStorage.getAcessToken();
    apiClient.setToken(token!);
    var loginResponse = await localStorage.getLoginResponse();
    if (loginResponse != null) {}

    print(token);

    final response = await apiClient.request(
        path: 'datas/fetch/homefeed',
        method: MethodType.get,
        fromJsonT: (json) => PostModel.fromJson(json));

    // if(response.success!){
    //   response.data.
    // }

    print(response);

    return response;
  }

  @override
  Future<ApiResponse<GetStatusModel>> getStatus() async {
    String? token = await localStorage.getAcessToken();
    apiClient.setToken(token!);

    print(token);

    final response = await apiClient.request(
        path: 'datas/fetch/status',
        method: MethodType.get,
        fromJsonT: (json) => GetStatusModel.fromJson(json));

    print(response);

    return response;
  }

  @override
  Future<ApiResponse> createFeed({required CreateFeedsParams params}) async {
    // String? token = await localStorage.getAcessToken();
    String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIsImVtYWlsIjoic2FtdWVsb2Znb2RAZ21haWwuY29tIiwiZmlyc3RfbmFtZSI6IlNhbXVlbCIsImxhc3RfbmFtZSI6IlNhbGFtaSIsImdlbmRlciI6Ik1hbGUiLCJjb25maXJtX3NleF9hdF9iaXJ0aCI6MCwiZG9iIjpudWxsLCJldGhuaWNpdHkiOm51bGwsInJlbGlnaW91cyI6bnVsbCwibWFyaXRhbF9zdGF0dXMiOm51bGwsImNvdW50cnkiOm51bGwsImNpdHkiOm51bGwsInN0cmVldCI6bnVsbCwicG9zdGFsX2NvZGUiOm51bGwsInNjaG9vbF9uYW1lIjpudWxsLCJjb3Vyc2Vfb2Zfc3R1ZHkiOm51bGwsInllYXJfaW5fc2Nob29sIjpudWxsLCJpbmR1c3RyeSI6bnVsbCwic3BlY2lhbHR5IjpudWxsLCJqb2JfdGl0bGUiOm51bGwsInByb2dyYW1fdHlwZSI6bnVsbCwicHJvZmlsZV9pbWFnZSI6Imh0dHBzOi8vcmVzLmNsb3VkaW5hcnkuY29tL2FuaW1vcGxhc3R5L2ltYWdlL3VwbG9hZC92MTczMzIzMjY1OC9zdHVkZW50cmljL3VzZXJQcm9maWxlL2ZzcDdreWl4aHIyeDF6bnI5azdjLnBuZyIsInBob25lX251bWJlciI6IisyMzQ3MDM1MTEyMDAxIiwib3RwX2NvZGUiOjUzNDI1OSwib3RwX2NvZGVfU01TIjoiMTg2ODM1IiwicGluX2lkIjoiY2FmYTVjNjItMzE3OS00OTlmLWIxNjAtNDUzNDFhMTYxZjI5Iiwib3RwX2V4cGlyYXRpb24iOiIyMDI0LTExLTEyIDA4OjQxOjE0IiwiaXNfcGhvbmVfdmVyaWZ5IjpmYWxzZSwiaXNfZW1haWxfdmVyaWZ5Ijp0cnVlLCJpc19iYXNpY19pbmZvcm1hdGlvbl92ZXJpZnkiOmZhbHNlLCJpc19hZGRyZXNzX3ZlcmlmeSI6ZmFsc2UsImlzX3NjaG9vbF92ZXJpZnkiOmZhbHNlLCJpc19vY2N1cGF0aW9uX3ZlcmlmeSI6ZmFsc2UsImlzX3Byb2ZpbGVfdXBsb2FkIjpmYWxzZSwiZmlyZWJhc2VUb2tlbiI6ImM4TkFha0o2UVltLTd1Q1A5Wk1CS2I6QVBBOTFiSGt0VG45S0otTWVLek9VUkd0UHlCcVFUV2xZTFdKdWlVaTVucmFDcUR1dzlnSlpKTlNWa2dYQlhNMDRPOXN1U3NkLWFoTDRWZk51THhVd1hmenJrcVdyOEdEWlFPRVZlbGwzbmhEeTJwTFRFUHRYZGciLCJjcmVhdGVkX2F0IjoiMjAyNC0xMS0wNlQyMDo1NDo0Ni4wMDBaIiwidXBkYXRlZF9hdCI6IjIwMjQtMTItMDNUMTM6MzE6MDcuMDAwWiIsImlhdCI6MTczMzM0MjczNiwiZXhwIjoxNzMzOTQ3NTM2fQ.VW_vge8wvszCMCZyaqRaTZSG38F0omkj8Bu6TwCFL6U';
    // dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) {
    //     print("REQUEST[${options.method}] => PATH: ${options.path}");
    //     print("HEADERS: ${options.headers}");
    //     print("DATA: ${options.data}");
    //     return handler.next(options);
    //   },
    //   onError: (DioError e, handler) {
    //     print(
    //         "ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}");
    //     print("DATA: ${e.response?.data}");
    //     return handler.next(e);
    //   },
    // ));

    FormData formData = await params.toFormData();
    formData.fields.forEach((field) {
      print('Field: ${field.key}, Value: ${field.value}');
    });
    formData.files.forEach((file) {
      print('File: ${file.key}, Filename: ${file.value.filename}');
    });

    try {
      final response = await dio.post(
          'https://typescript-boilerplate.onrender.com/api/v1/datas/home/postToFeed',
          data: params.toFormData(),
          options: Options(headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          }));
      return ApiResponse(
        success: true,
        rawJson: response.data,
      );
    } catch (e) {
      //DebugLogger.log('DIO ERROR', e.toString());
      var err = CustomHandlerObject.getError(error: e);
      final apiResponse = ApiResponse(
        success: false,
        failure: err,
      );
      return apiResponse;
    }
  }
}
