import 'package:biznet_workforce_activity/features/activity/data/datasources/activity_remote_datasource.dart';
import 'package:biznet_workforce_activity/features/activity/data/models/activity_model.dart';
import 'package:biznet_workforce_activity/features/activity/domain/entities/activity.dart';
import 'package:biznet_workforce_activity/features/activity/domain/repositories/activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource remoteDataSource;

  ActivityRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Activity>> getActivities() {
    return remoteDataSource.getActivities();
  }

  @override
  Future<void> addActivity(Activity activity) {
    final activityModel = ActivityModel(
      id: activity.id,
      judul: activity.judul,
      deskripsi: activity.deskripsi,
      lokasi: activity.lokasi,
      longLat: activity.longLat,
      jamMulai: activity.jamMulai,
      jamSelesai: activity.jamSelesai,
      status: activity.status,
      prioritas: activity.prioritas,
      timestampCreated: activity.timestampCreated,
      timestampUpdated: activity.timestampUpdated,
    );

    return remoteDataSource.addActivity(activityModel);
  }

  @override
  Future<void> deleteActivity(String id) {
    return remoteDataSource.deleteActivity(id);
  }

  @override
  Future<void> updateActivity(Activity activity) {
    final activityModel = ActivityModel(
      id: activity.id,
      judul: activity.judul,
      deskripsi: activity.deskripsi,
      lokasi: activity.lokasi,
      longLat: activity.longLat,
      jamMulai: activity.jamMulai,
      jamSelesai: activity.jamSelesai,
      status: activity.status,
      prioritas: activity.prioritas,
      timestampCreated: activity.timestampCreated,
      timestampUpdated: activity.timestampUpdated,
    );

    return remoteDataSource.updateActivity(activityModel);
  }

  @override
  Future<Activity?> getDetailActivity(String id) {
    return remoteDataSource.getDetailActivity(id);
  }
}
