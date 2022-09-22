import 'package:dartz/dartz.dart';
import 'package:posts_app_clean_architecture/features/posts/domain/repo/post_repo.dart';

import '../../../../core/error/failure.dart';

class DeletePostsUseCase {
  final PostRepo repo;

  DeletePostsUseCase(this.repo);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repo.deletePost(id);
  }
}
