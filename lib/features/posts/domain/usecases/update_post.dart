import 'package:cleen_acrch_posts_app/features/posts/domain/reposetory/posts_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/post.dart';

class UpdatePostUsecase {
  final PostsRepository repository;

  UpdatePostUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Post post) async {
    return await repository.updatePost(post);
  }
}