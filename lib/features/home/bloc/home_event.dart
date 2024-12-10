part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {}

class GetFeeds extends HomeEvent {
  @override
  List<Object> get props => [];
}

class GetStatus extends HomeEvent {
  @override
  List<Object> get props => [];
}

class ToggleLike extends HomeEvent {
  final int postId;

  ToggleLike({
    required this.postId,
  });

  @override
  List<Object> get props => [
        postId,
      ];
}
