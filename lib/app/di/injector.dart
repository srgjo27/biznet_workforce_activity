import 'package:biznet_workforce_activity/features/activity/data/datasources/activity_remote_datasource.dart';
import 'package:biznet_workforce_activity/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:biznet_workforce_activity/features/activity/domain/repositories/activity_repository.dart';
import 'package:biznet_workforce_activity/features/activity/domain/usecases/manage_activity.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupInjector() {
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // BLoC
  sl.registerFactory(
    () => ActivityBloc(
      getActivities: sl(),
      addActivity: sl(),
      updateActivity: sl(),
      deleteActivity: sl(),
      getDetailActivity: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetActivities(sl()));
  sl.registerLazySingleton(() => AddActivity(sl()));
  sl.registerLazySingleton(() => UpdateActivity(sl()));
  sl.registerLazySingleton(() => DeleteActivity(sl()));
  sl.registerLazySingleton(() => GetDetailActivity(sl()));

  // Repository
  sl.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ActivityRemoteDataSource>(
    () => ActivityRemoteDataSourceImpl(firestore: sl()),
  );
}
