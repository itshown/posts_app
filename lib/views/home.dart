import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/views/widgets/post_card.dart';

import '../blocs/posts_bloc.dart';
import '../blocs/posts_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  PostsState? currentState;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        currentState is! LoadMorePostsEvent) {
      BlocProvider.of<PostsBloc>(context).add(LoadMorePostsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is LoadingPostsState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadedPostsState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Posts"),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(state.viewMode == ViewMode.listView
                      ? Icons.grid_view_rounded
                      : Icons.view_list),
                  onPressed: () {
                    BlocProvider.of<PostsBloc>(context)
                        .add(ToggleViewModeEvent());
                  },
                )
              ],
            ),
            body: _bodyWidget(state),
          );
        } else if (state is FailedToLoadPostsState) {
          return Container(
            color: Colors.red,
            child: Center(
              child: Text(
                '${state.error}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _bodyWidget(LoadedPostsState state) {
    return Column(
      children: [
        TextField(
          onChanged: (query) {
            BlocProvider.of<PostsBloc>(context).add(SearchPostsEvent(query));
          },
          onSubmitted: (query) {
            BlocProvider.of<PostsBloc>(context).add(SearchPostsEvent(query));
          },
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        // data
        Expanded(
          child: state.viewMode == ViewMode.listView
              ? ListView.builder(
                  controller: _scrollController,
                  itemCount: state.posts.length,
                  itemBuilder: (ctx, i) {
                    return PostCard(post: state.posts[i]);
                  },
                )
              : GridView.builder(
                  controller: _scrollController,
                  itemCount: state.posts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (ctx, i) {
                    return PostCard(post: state.posts[i]);
                  },
                ),
        )
      ],
    );
  }
}
