import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_centric_app/config/service_locator.dart';
import 'package:student_centric_app/features/home/data/home_repo.dart';
import 'package:student_centric_app/features/home/models/get_status_model.dart';

import '../../../core/api/api.dart';
import '../../../core/storage/local_storage.dart';
import '../models/posts_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final homeRepo = Di.getIt<HomeRepo>();
  final localStorage = Di.getIt<LocalStorage>();

  HomeBloc()
      : super(
          const HomeState(status: HomeStatus.initial),
        ) {
    on<GetFeeds>(_fetchFeeds);
    on<GetStatus>(_fetchStatus);
  }

  // Future<void> _toggleLike(ToggleLike event, Emitter<HomeState> emit) async {
  //   final currentPosts = state.posts;

  //   final updatedPosts = currentPosts!.data!.map((post) {
  //     if (post.id == event.postId) {
  //       //toggle isLiked
  //       final alreadyLiked = post.likeOnFeeds
  //               ?.any((like) => like.feedLike.toString() == event.userId) ??
  //           false;
  //       post.isLiked = !alreadyLiked;
  //     }
  //     return post;
  //   }).toList();

  //   emit(state.copyWith(
  //     posts: PostModel(
  //       data: updatedPosts,
  //     ),
  //   ));
  // }

  Future<void> _fetchFeeds(GetFeeds event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await homeRepo.getPost();
    result.fold((failure) {
      emit(state.copyWith(status: HomeStatus.error, error: failure));
    }, (posts) async {
      // var loginResponse = await localStorage.getLoginResponse();
      // if (loginResponse != null) {
      //   for (var post in posts.data!) {
      //     post.updateIsLiked(loginResponse.id.toString());
      //   }
      // }

      emit(state.copyWith(status: HomeStatus.success, posts: posts));
    });
  }

  Future<void> _fetchStatus(GetStatus event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await homeRepo.getStatus();
    result.fold((failure) {
      emit(state.copyWith(status: HomeStatus.error, error: failure));
    }, (status) {
      emit(state.copyWith(status: HomeStatus.success, statusModel: status));
    });
  }
}
