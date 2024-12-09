import 'package:dartz/dartz.dart';
import 'package:student_centric_app/config/service_locator.dart';
import 'package:student_centric_app/features/home/data/home_service.dart';

import '../../../core/utils/type_def.dart';
import '../models/get_status_model.dart';
import '../models/posts_model.dart';

abstract class HomeRepo {
  ApiResult<PostModel> getPost();
  ApiResult<GetStatusModel> getStatus();
}

class HomeRepoImpl extends HomeRepo {
  final homeService = Di.getIt<HomeService>();
  @override
  ApiResult<PostModel> getPost() async {
    final response = await homeService.getFeeds();
    if (response.success!) {
      return Right(response.data!);
    } else {
      return Left(response.failure!);
    }
  }

  @override
  ApiResult<GetStatusModel> getStatus() async {
    final response = await homeService.getStatus();
    if (response.success!) {
      return Right(response.data!);
    } else {
      return Left(response.failure!);
    }
  }
}
