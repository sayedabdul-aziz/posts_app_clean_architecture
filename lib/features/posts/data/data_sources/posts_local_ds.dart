import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_architecture/core/error/exceptions.dart';
import 'package:posts_app_clean_architecture/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostsLocaleDataSource {
  Future<List<PostModel>> getCachedPosts();
  Future<Unit> cachePosts(List<PostModel> posts);
}

const CACHED_POSTS = "CACHED_POSTS";

class PostsLocaleDataSourceImpl implements PostsLocaleDataSource {
  final SharedPreferences pref;

  PostsLocaleDataSourceImpl({required this.pref});
  @override
  Future<Unit> cachePosts(List<PostModel> postModels) {
    List postModelToJson = postModels
        .map<Map<String, dynamic>>((postModel) => postModel.toJson())
        .toList();
    pref.setString(CACHED_POSTS, json.encode(postModelToJson));
    return Future.value(unit);
  }

  @override
  Future<List<PostModel>> getCachedPosts() {
    var jsonString = pref.getString(CACHED_POSTS);
    if (jsonString != null) {
      List decodedData = json.decode(jsonString);
      List<PostModel> jsonToPostModel = decodedData
          .map<PostModel>((posts) => PostModel.fromJson(posts))
          .toList();
      return Future.value(jsonToPostModel);
    } else {
      throw EmptyCachedException();
    }
  }
}
