import 'package:cleen_acrch_posts_app/core/error/failures.dart';
import 'package:cleen_acrch_posts_app/features/posts/domain/entities/post.dart';
import 'package:cleen_acrch_posts_app/features/posts/domain/reposetory/posts_repository.dart';
import 'package:dartz/dartz.dart';

class SearchPosts {
  final PostsRepository repository;

  SearchPosts(this.repository);

  Future<Either<Failure, List<Post>>> call(int id) async {
    return await repository.searchposts(id);
  }

}