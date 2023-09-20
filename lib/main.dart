import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/views/home.dart';

import 'blocs/posts_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<PostsBloc>(
        create: (context) => PostsBloc()..add(LoadPostsEvent()),
        child: const Home(),
      ),
    );
  }
}
