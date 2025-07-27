import 'package:biznet_workforce_activity/features/activity/data/models/activity_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ActivityRemoteDataSource {
  Stream<List<ActivityModel>> getActivities();
  Future<void> addActivity(ActivityModel activity);
  Future<void> updateActivity(ActivityModel activity);
  Future<void> deleteActivity(String id);
  Future<ActivityModel> getDetailActivity(String id);
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final FirebaseFirestore firestore;
  late final CollectionReference _activityCollection;

  ActivityRemoteDataSourceImpl({required this.firestore}) {
    _activityCollection = firestore.collection('activities');
  }

  @override
  Stream<List<ActivityModel>> getActivities() {
    return _activityCollection
        .orderBy('timestamp_created', descending: true)
        .snapshots()
        .map((snapshots) {
          return snapshots.docs
              .map((doc) => ActivityModel.fromSnapshot(doc))
              .toList();
        });
  }

  @override
  Future<void> addActivity(ActivityModel activity) {
    return _activityCollection.add(activity.toMap());
  }

  @override
  Future<void> deleteActivity(String id) {
    return _activityCollection.doc(id).delete();
  }

  @override
  Future<void> updateActivity(ActivityModel activity) {
    return _activityCollection.doc(activity.id).update(activity.toMap());
  }

  @override
  Future<ActivityModel> getDetailActivity(String id) {
    return _activityCollection.doc(id).get().then((doc) {
      return ActivityModel.fromSnapshot(doc);
    });
  }
}
