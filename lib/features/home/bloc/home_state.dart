// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

enum HomeStatus { loading, error, success, initial }

class HomeState extends Equatable {
  final Failure? error;
  final PostModel? posts;
  final GetStatusModel? statusModel;
  final HomeStatus status;
  const HomeState(
      {this.error, this.posts, required this.status, this.statusModel});
  @override
  List<Object?> get props => [
        error,
        posts,
        status,
        statusModel,
      ];

  HomeState copyWith({
    Failure? error,
    PostModel? posts,
    HomeStatus? status,
    GetStatusModel? statusModel,
  }) {
    return HomeState(
        error: error ?? this.error,
        posts: posts ?? this.posts,
        status: status ?? this.status,
        statusModel: statusModel ?? this.statusModel);
  }
}
