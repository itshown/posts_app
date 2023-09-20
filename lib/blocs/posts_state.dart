import 'package:flutter/cupertino.dart';

import '../models/post.dart';

enum ViewMode { listView, gridView }

@immutable
abstract class PostsState {
  final ViewMode viewMode;

  const PostsState({required this.viewMode});
}

class LoadingPostsState extends PostsState {
  const LoadingPostsState({required ViewMode viewMode}) : super(viewMode: viewMode);
}

class LoadedPostsState extends PostsState {
  final List<Post> posts;
  const LoadedPostsState({required this.posts, required ViewMode viewMode})
      : super(viewMode: viewMode);

  LoadedPostsState copyWith({List<Post>? posts}) {
    return LoadedPostsState(
      posts: posts ?? this.posts,
      viewMode: viewMode,
    );
  }
}

class FailedToLoadPostsState extends PostsState {
  final Object error;
  const FailedToLoadPostsState({required this.error, required ViewMode viewMode})
      : super(viewMode: viewMode);
}