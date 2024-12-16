import 'dart:convert';
import 'package:cleen_acrch_posts_app/core/exception.dart';
import 'package:cleen_acrch_posts_app/features/posts/data/model/post_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
  Future<Unit> deletePost(int postId);
  Future<Unit> updatePost(PostModel postModel);
  Future<Unit> addPost(PostModel postModel);
}

const BASE_URL = "https://dummyjson.com";

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;

  PostRemoteDataSourceImpl({required this.client});

  static const headers = {"Content-Type": "application/json"};

  @override
  Future<List<PostModel>> getAllPosts() async {
    final response = await client.get(
      Uri.parse("$BASE_URL/posts/"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final List<dynamic> postsJson = decodedJson['posts'] as List<dynamic>;

      final List<PostModel> postModels = postsJson
          .map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel))
          .toList();

      return postModels;
    } else {
      throw ServerException(
          message: "Failed to fetch posts. Status code: ${response.statusCode}");
    }
  }

  @override
  Future<Unit> addPost(PostModel postModel) async {
    final body = jsonEncode({
      "title": postModel.title,
      "body": postModel.body,
    });

    final response = await client.post(
      Uri.parse("$BASE_URL/posts/"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException(
          message: "Failed to add post. Status code: ${response.statusCode}");
    }
  }

  @override
  Future<Unit> deletePost(int postId) async {
    final response = await client.delete(
      Uri.parse("$BASE_URL/posts/$postId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException(
          message: "Failed to delete post. Status code: ${response.statusCode}");
    }
  }

  @override
  Future<Unit> updatePost(PostModel postModel) async {
    final body = jsonEncode({
      "title": postModel.title,
      "body": postModel.body,
    });

    final response = await client.patch(
      Uri.parse("$BASE_URL/posts/${postModel.id}"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException(
          message: "Failed to update post. Status code: ${response.statusCode}");
    }
  }
}
