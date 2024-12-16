// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:cleen_acrch_posts_app/core/network/network_info.dart';
import 'package:cleen_acrch_posts_app/features/posts/data/datasources/post_local_data_source.dart';
import 'package:cleen_acrch_posts_app/features/posts/data/datasources/post_remot_data_source.dart';
import 'package:cleen_acrch_posts_app/features/posts/data/repositores/post_repository_impl.dart';
import 'package:cleen_acrch_posts_app/features/posts/domain/reposetory/posts_repository.dart';
import 'package:cleen_acrch_posts_app/features/posts/domain/usecases/add_post.dart';
import 'package:cleen_acrch_posts_app/features/posts/domain/usecases/delete_post.dart';
import 'package:cleen_acrch_posts_app/features/posts/domain/usecases/get_all_posts.dart';
import 'package:cleen_acrch_posts_app/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:cleen_acrch_posts_app/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/posts/domain/usecases/update_post.dart';

final Sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  Sl.registerLazySingleton(() => sharedPreferences);
  Sl.registerLazySingleton(() => http.Client());
  Sl.registerLazySingleton<NetworkInfo>(() => MockNetworkInfo());

  //! Data Sources
  Sl.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(client: Sl()));

  Sl.registerLazySingleton<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(sharedPreferences: Sl()));

  //! Repository
  Sl.registerLazySingleton<PostsRepository>(() => PostsRepositoryImpl(
        remoteDataSource: Sl(),
        localDataSource: Sl(),
        networkInfo: Sl(),
      ));

  //! Usecases
  Sl.registerLazySingleton(() => GetAllPostsUsecases(Sl()));
  Sl.registerLazySingleton(() => AddPostUsecase(Sl()));
  Sl.registerLazySingleton(() => UpdatePostUsecase(Sl()));
  Sl.registerLazySingleton(() => DeletePostUsecases(Sl()));
  //! Blocs
  Sl.registerFactory(() {
    print('Registering PostsBloc');
    return PostsBloc(getAllPosts: Sl());
  });

  Sl.registerFactory(() => AddDeleteUpdatePostBloc(
      addPost: Sl(), updatePost: Sl(), deletePost: Sl()));
}


