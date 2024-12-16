import 'package:cleen_acrch_posts_app/core/error/failures.dart';
import 'package:cleen_acrch_posts_app/features/posts/domain/reposetory/posts_repository.dart';
import 'package:dartz/dartz.dart';

class SortPosts {
  final PostsRepository repository;

  SortPosts(this.repository);
  
  Future<Either<Failure, Unit>> call(int id) {
    return repository.sortposts(id);
  }
}