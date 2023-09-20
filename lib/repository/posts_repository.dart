import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostsRepository {
  final String baseUrl = 'jsonplaceholder.typicode.com';

  /// end-points
  final String postsEndpoint = '/posts';

  Future<List<Post>> getPosts() async {
    try {
      Uri url = Uri.parse("https://$baseUrl$postsEndpoint?_start=1&limit=10");
      final http.Response response = await http.get(url);
      final List<dynamic> data = jsonDecode(response.body);
      final List<Post> posts = data.map((json) => Post.fromJson(json)).toList();
      return posts;
    } catch (e) {
      throw Exception('Error loading posts');
    }
  }

  Future<List<Post>> getMorePosts(int startIndex) async {
    try {
      Uri url = Uri.parse("https://$baseUrl$postsEndpoint?_start=$startIndex&limit=10");
      final http.Response response = await http.get(url);
      final List<dynamic> data = jsonDecode(response.body);
      final List<Post> posts = data.map((json) => Post.fromJson(json)).toList();
      return posts;
    } catch (e) {
      throw Exception('Error loading more posts');
    }
  }
}