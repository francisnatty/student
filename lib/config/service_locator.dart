import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:student_centric_app/features/chats/bloc/chat_bloc.dart';
import 'package:student_centric_app/features/chats/services/chat_repo.dart';
import 'package:student_centric_app/features/chats/services/chat_service.dart';
import 'package:student_centric_app/features/home/data/home_repo.dart';
import 'package:student_centric_app/features/tasks/data/task_repo.dart';
import 'package:student_centric_app/features/tasks/data/task_service.dart';

import '../core/api/api.dart';
import '../core/storage/local_storage.dart';
import '../features/home/bloc/home_bloc.dart';
import '../features/home/data/home_service.dart';

class Di {
  static late GetIt getIt;

  static Future<void> setUpLocator() async {
    getIt = GetIt.instance;
    initialize();
  }

  static void initialize() {
    initializeServices();
    initializeBloc();
    // initializeLocalDataSources();
    initializeRepositories();
    initializePackages();
    // initUsecase();
  }

  static void initializePackages() {
    getIt.registerLazySingleton<ApiClient>(
      () => DioClient(),
    );

    getIt.registerLazySingleton<Dio>(
      () => Dio(),
    );

    getIt.registerLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage());
    getIt.registerLazySingleton<LocalStorage>(() => LocalStorageImpl());
  }

  static void initializeServices() {
    getIt.registerLazySingleton<HomeService>(() => HomeServiceImpl());
    getIt.registerLazySingleton<TaskService>(() => TaskServiceImpl());
    getIt.registerLazySingleton<ChatService>(() => ChatServiceImpl());
  }

  static void initializeBloc() {
    getIt.registerLazySingleton<HomeBloc>(() => HomeBloc());
    getIt.registerLazySingleton<ChatBloc>(() => ChatBloc());
  }

  static void initializeRepositories() {
    getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImpl());
    getIt.registerLazySingleton<TaskRepo>(() => TaskRepoImpl());
    getIt.registerLazySingleton<ChatRepo>(() => ChatRepoImpl());
  }
}
