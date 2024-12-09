import 'package:dartz/dartz.dart';

import '../api/api.dart';

typedef ApiResult<T> = Future<Either<Failure, T>>;
