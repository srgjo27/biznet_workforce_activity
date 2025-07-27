import 'package:biznet_workforce_activity/features/activity/domain/entities/activity.dart';
import 'package:biznet_workforce_activity/features/activity/domain/repositories/activity_repository.dart';

class GetActivities {
  final ActivityRepository repository;

  GetActivities(this.repository);

  Stream<List<Activity>> call() {
    return repository.getActivities();
  }
}

class AddActivity {
  final ActivityRepository repository;
  AddActivity(this.repository);

  Future<void> call(Activity activity) {
    return repository.addActivity(activity);
  }
}

class UpdateActivity {
  final ActivityRepository repository;
  UpdateActivity(this.repository);

  Future<void> call(Activity activity) {
    return repository.updateActivity(activity);
  }
}

class DeleteActivity {
  final ActivityRepository repository;
  DeleteActivity(this.repository);

  Future<void> call(String id) {
    return repository.deleteActivity(id);
  }
}

class GetDetailActivity {
  final ActivityRepository repository;

  GetDetailActivity(this.repository);

  Future<Activity?> call(String id) {
    return repository.getDetailActivity(id);
  }
}
