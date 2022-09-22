import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_architecture/core/error/exceptions.dart';
import 'package:posts_app_clean_architecture/features/posts/data/models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
  Future<Unit> addPost(PostModel postModel);
  Future<Unit> deletePost(int postId);
  Future<Unit> updatePost(PostModel postModel);
}

const BASE_URL = "https://jsonplaceholder.typicode.com";

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final http.Client client;

  PostsRemoteDataSourceImpl({required this.client});
  @override
  Future<List<PostModel>> getAllPosts() async {
    final response = await client.get(Uri.parse(BASE_URL + "/posts/"),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final List decodeData = json.decode(response.body) as List;
      final List<PostModel> postModels = decodeData
          .map<PostModel>((jsonData) => PostModel.fromJson(jsonData))
          .toList();
      return Future.value(postModels);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addPost(PostModel postModel) async {
    final body = {'title': postModel.title, 'body': postModel.body};
    final response = await client.post(
        Uri.parse(
          BASE_URL + "/posts/",
        ),
        body: body);
    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePost(int postId) async {
    final response = await client.delete(
        Uri.parse(
          BASE_URL + "/posts/${postId}",
        ),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updatePost(PostModel postModel) async {
    final body = {'title': postModel.title, 'body': postModel.body};
    final response = await client.patch(
        Uri.parse(
          BASE_URL + "/posts/${postModel.id}",
        ),
        body: body);
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
