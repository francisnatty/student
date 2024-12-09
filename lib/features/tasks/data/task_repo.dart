import 'package:student_centric_app/config/service_locator.dart';
import 'package:student_centric_app/core/utils/type_def.dart';
import 'package:student_centric_app/features/tasks/data/task_service.dart';
import 'package:student_centric_app/features/tasks/models/create_task_params.dart';

abstract class TaskRepo {
  ApiResult<String> createTask({required CreateTaskParams params});
  // ApiResult<
}

class TaskRepoImpl extends TaskRepo {
  final taskService = Di.getIt<TaskService>();
  @override
  ApiResult<String> createTask({required CreateTaskParams params}) {
    // TODO: implement createTask
    throw UnimplementedError();
  }
}
