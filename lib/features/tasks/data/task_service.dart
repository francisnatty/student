import 'package:dio/dio.dart';
import 'package:student_centric_app/features/tasks/models/create_task_params.dart';

import '../../../config/service_locator.dart';
import '../../../core/api/api.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/debug_logger.dart';

abstract class TaskService {
  Future<ApiResponse> createTask({required CreateTaskParams params});
  Future<ApiResponse> getTasks();
}

class TaskServiceImpl extends TaskService {
  final apiClient = Di.getIt<ApiClient>();
  final localStorage = Di.getIt<LocalStorage>();
  Dio dio = Dio();
  @override
  Future<ApiResponse> createTask({required CreateTaskParams params}) async {
    String? token = await localStorage.getAcessToken();

    // final response = await apiClient.request(
    //   path: '',
    //   method: MethodType.post,
    //   payload: params.toFormData(),
    // );
    try {
      final response = await dio.post(
          'https://typescript-boilerplate.onrender.com/api/v1/task/create-task',
          data: params.toFormData(),
          options: Options(headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          }));

// var response = await dio.request(
//   'https://typescript-boilerplate.onrender.com/api/v1/auth/onboarding/upload/user/profilePicture',
//   options: Options(
//     method: 'PATCH',
//   ),
//   data: data,
// );
      return ApiResponse(
        success: true,
        rawJson: response.data,
      );
    } catch (e) {
      DebugLogger.log('DIO ERROR', e.toString());
      var err = CustomHandlerObject.getError(error: e);
      final apiResponse = ApiResponse(
        success: false,
        failure: err,
      );
      return apiResponse;
    }
  }

  @override
  Future<ApiResponse> getTasks() {
    // TODO: implement getTasks
    throw UnimplementedError();
  }
}
