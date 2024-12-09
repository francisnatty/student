// import 'package:dio/dio.dart';

// import '../../../config/di/di.dart';
// import '../../localStorage/local_storage.dart';
// import '../../utils/debug_logger.dart';

// class CustomInterceptor extends Interceptor {
//   final Dio dio;

//   CustomInterceptor({required this.dio});

//   LocalStorage localStorage = Di.getIt<LocalStorage>();

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
//       final response = await _refreshTokenRequest();
//       if (response?.statusCode == 200) {
//         var newAccessToken = response!.data['token'];

//         DebugLogger.log('PRINT ACCESSTOKEN', newAccessToken);

//         final options = err.requestOptions;
//         options.headers['Authorization'] = 'Bearer $newAccessToken';
//         final retryResponse = await dio.request(options.path,
//             options: Options(
//               method: options.method,
//               headers: options.headers,
//             ));

//         return handler.resolve(retryResponse);
//       }
//     }
//     handler.next(err);
//   }

//   @override
//   void onRequest(
//       RequestOptions options, RequestInterceptorHandler handler) async {
//     handler.next(options);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     handler.next(response);
//   }

//   Future<Response?> _refreshTokenRequest() async {
//     final refreshToken = await localStorage.getRefreshToke();

//     try {
//       final response = await dio.post(
//           'https://sina-62043178b88f.herokuapp.com/api/refresh-token',
//           data: {'refreshToken': refreshToken});
//       if (response is Map) {
//         var ii = response.data['message'];
//         DebugLogger.log('response', ii);
//       }
//       DebugLogger.log('REFRESH TOKEN ERROR', response);
//       return response;
//     } catch (e) {
//       DebugLogger.log('REFRESH TOKEN ERROR', e.toString());
//       return null;
//     }
//   }
// }
