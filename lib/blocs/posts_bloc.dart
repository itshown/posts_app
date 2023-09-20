import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:posts_app/blocs/posts_state.dart';

import '../models/post.dart';
import '../repository/posts_repository.dart';

part 'posts_event.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository _postsRepository = PostsRepository();
  var viewMode = ViewMode.listView;

  PostsBloc() : super(const LoadingPostsState(viewMode: ViewMode.listView)) {
    on<LoadPostsEvent>((event, emit) => _onPostsLoaded(event, emit));
    on<PullToRefreshPostsEvent>((event, emit) => _onPostsLoaded(event, emit));
    on<LoadMorePostsEvent>((event, emit) => _onLoadMorePosts(event, emit));
    on<ToggleViewModeEvent>((event, emit) => _onPostsLoaded(event, emit));
    on<SearchPostsEvent>((event, emit) => _onPostsLoaded(event, emit));
  }

  Future<void> _onPostsLoaded(
      PostsEvent event, Emitter<PostsState> emit) async {
    List<Post> posts; Object occurredError = "";
    try {
      posts = await _postsRepository.getPosts();
      if (event is LoadPostsEvent || event is PullToRefreshPostsEvent) {
        emit(LoadingPostsState(viewMode: state.viewMode));

        emit(LoadedPostsState(posts: posts, viewMode: state.viewMode));
      } else if (event is ToggleViewModeEvent) {
        final newViewMode = state.viewMode == ViewMode.listView
            ? ViewMode.gridView
            : ViewMode.listView;

        if (state is LoadingPostsState) {
          emit(LoadingPostsState(viewMode: newViewMode));
        } else if (state is LoadedPostsState) {
          emit(LoadedPostsState(posts: posts, viewMode: newViewMode));
        } else if (state is FailedToLoadPostsState) {
          emit(FailedToLoadPostsState(
              error: occurredError, viewMode: newViewMode));
        }
      } else if (event is SearchPostsEvent) {
        final currentState = state;
        if (currentState is LoadedPostsState) {
          final filteredPosts = currentState.posts.where((post) =>
          post.title.toLowerCase().contains(event.query.toLowerCase())).toList();

          emit(currentState.copyWith(posts: filteredPosts));
        }
      }
    } catch (error) {
      occurredError = error;
      emit(FailedToLoadPostsState(
          error: occurredError, viewMode: state.viewMode));
    }
  }

  Future<void> _onLoadMorePosts(
      LoadMorePostsEvent event, Emitter<PostsState> emit) async {
    try {
      final loadedState = state as LoadedPostsState;
      final startIndex = loadedState.posts.length;
      final newPosts = await _postsRepository.getMorePosts(startIndex);

      final mergedPosts = loadedState.posts + newPosts;
      emit(loadedState.copyWith(posts: mergedPosts));
    } catch (error) {
      emit(FailedToLoadPostsState(
          error: 'Error loading more posts: $error', viewMode: state.viewMode));
    }
  }
}
