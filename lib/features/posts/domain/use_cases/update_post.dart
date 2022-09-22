import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:posts_app_clean_architecture/features/posts/domain/repo/post_repo.dart';

import '../../../../core/error/failure.dart';

class UpdatePostsUseCase {
  final PostRepo repo;

  UpdatePostsUseCase(this.repo);

  Future<Either<Failure, Unit>> call(Post post) async {
    return await repo.updatePost(post);
  }
}
