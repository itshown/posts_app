part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class LoadPostsEvent extends PostsEvent {}

class PullToRefreshPostsEvent extends PostsEvent {}

class LoadMorePostsEvent extends PostsEvent {}

class ToggleViewModeEvent extends PostsEvent {}

class SearchPostsEvent extends PostsEvent {
  final String query;

  SearchPostsEvent(this.query);
}
