import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_architecture/features/posts/domain/repo/post_repo.dart';

import '../../../../core/error/failure.dart';
import '../entities/post.dart';

class GetAllPostsUseCase {
  final PostRepo repo;

  GetAllPostsUseCase(this.repo);

  Future<Either<Failure, List<Post>>> call() async {
    return await repo.getAllPosts();
  }
}
