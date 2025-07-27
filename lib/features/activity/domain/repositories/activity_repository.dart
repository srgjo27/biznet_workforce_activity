import 'package:biznet_workforce_activity/features/activity/domain/entities/activity.dart';

abstract class ActivityRepository {
  Stream<List<Activity>> getActivities();
  Future<void> addActivity(Activity activity);
  Future<void> updateActivity(Activity activity);
  Future<void> deleteActivity(String id);
  Future<Activity?> getDetailActivity(String id);
}
