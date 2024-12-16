import 'package:cleen_acrch_posts_app/core/error/failures.dart';
import 'package:cleen_acrch_posts_app/features/posts/domain/reposetory/posts_repository.dart';
import 'package:dartz/dartz.dart';

class DeletePostUsecases {
  final PostsRepository repository;

  DeletePostUsecases(this.repository);

  Future<Either<Failure, Unit>> call(int postid) async {
    return await repository.deletePost(postid);
  }
}