import 'package:cleen_acrch_posts_app/core/error/failures.dart';
import 'package:cleen_acrch_posts_app/core/exception.dart';
import 'package:cleen_acrch_posts_app/core/network/network_info.dart';
import 'package:cleen_acrch_posts_app/features/posts/data/datasources/post_local_data_source.dart';
import 'package:cleen_acrch_posts_app/features/posts/data/datasources/post_remot_data_source.dart';
import 'package:cleen_acrch_posts_app/features/posts/data/model/post_model.dart';
import 'package:cleen_acrch_posts_app/features/posts/domain/entities/post.dart';
import 'package:cleen_acrch_posts_app/features/posts/domain/reposetory/posts_repository.dart';
import 'package:dartz/dartz.dart';

typedef DeleteOrUpdateOrAddPost = Future<Unit> Function();

class PostsRepositoryImpl implements PostsRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getAllPosts();
        localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure("Failed to fetch data from the server."));
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    final PostModel postModel = PostModel(title: post.title, body: post.body);

    return await _getMessage(() {
      return remoteDataSource.addPost(postModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int postId) async {
    return await _getMessage(() {
      return remoteDataSource.deletePost(postId);
    });
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);

    return await _getMessage(() {
      return remoteDataSource.updatePost(postModel);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure("Failed to fetch data from the server."));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> searchPosts(int id) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (id < 100) {
        return const Right(unit);
      } else {
        return Left(ServerFailure("Failed to fetch data from the server."));
      }
    } catch (e) {
      // Handle any unexpected errors
      return Left(ServerFailure("Failed to fetch data from the server."));
    }
  }

  @override
  Future<Either<Failure, Unit>> sortposts(int id) {
    throw UnimplementedError();
  }

  

  
 

  
  @override
  Future<Either<Failure, List<Post>>> searchposts(int id) async {
    try {
      // First, check if the device is connected to the internet
      if (await networkInfo.isConnected) {
        // Fetch posts from the remote data source
        final remotePosts = await remoteDataSource.getAllPosts();
        final filteredPosts =
            remotePosts.where((post) => post.id == id).toList();

        if (filteredPosts.isNotEmpty) {
          return Right(filteredPosts);
        } else {
          return Left(ServerFailure("No posts found matching the given ID."));
        }
      } else {
        // Fetch posts from the local data source
        final localPosts = await localDataSource.getCachedPosts();
        final filteredPosts =
            localPosts.where((post) => post.id == id).toList();

        if (filteredPosts.isNotEmpty) {
          return Right(filteredPosts);
        } else {
          return Left(EmptyCacheFailure());
        }
      }
    } on ServerException {
      return Left(ServerFailure("Failed to fetch data from the server."));
    } on EmptyCacheException {
      return Left(EmptyCacheFailure());
    } catch (e) {
      return Left(ServerFailure("An unexpected error occurred: $e"));
    }
  }
  
  
}
