import 'package:posts_app_clean_architecture/core/error/exceptions.dart';
import 'package:posts_app_clean_architecture/core/network/check_internet.dart';
import 'package:posts_app_clean_architecture/features/posts/data/data_sources/posts_remote_ds.dart';
import 'package:posts_app_clean_architecture/features/posts/data/models/post_model.dart';
import 'package:posts_app_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:posts_app_clean_architecture/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_architecture/features/posts/domain/repo/post_repo.dart';

import '../data_sources/posts_local_ds.dart';

class PostsRepoImpl implements PostRepo {
  final PostsRemoteDataSource remotePostsdata;
  final PostsLocaleDataSource localePostsdata;
  final CheckInternet checkInternet;

  PostsRepoImpl(this.remotePostsdata, this.localePostsdata, this.checkInternet);

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await checkInternet.isConnected) {
      try {
        var remotePosts = await remotePostsdata.getAllPosts();
        localePostsdata.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        var cachedPosts = await localePostsdata.getCachedPosts();
        return Right(cachedPosts);
      } on EmptyCachedException {
        return Left(CachedPostsFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    var postModel = PostModel(id: post.id, title: post.title, body: post.body);
    return await _get(() {
      return remotePostsdata.addPost(postModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int id) async {
    return await _get(() {
      return remotePostsdata.deletePost(id);
    });
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    var postModel = PostModel(id: post.id, title: post.title, body: post.body);
    return await _get(() {
      return remotePostsdata.updatePost(postModel);
    });
  }

  Future<Either<Failure, Unit>> _get(Future<Unit> Function() action) async {
    if (await checkInternet.isConnected) {
      try {
        await action();
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
