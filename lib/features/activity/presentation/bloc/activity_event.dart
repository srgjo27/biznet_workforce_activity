import 'package:biznet_workforce_activity/features/activity/domain/entities/activity.dart';
import 'package:equatable/equatable.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

class LoadActivities extends ActivityEvent {}

class ActivitiesUpdated extends ActivityEvent {
  final List<Activity> activities;

  const ActivitiesUpdated(this.activities);

  @override
  List<Object?> get props => [activities];
}

class AddActivityRequested extends ActivityEvent {
  final Activity activity;

  const AddActivityRequested(this.activity);

  @override
  List<Object?> get props => [activity];
}

class UpdateActivityRequested extends ActivityEvent {
  final Activity activity;

  const UpdateActivityRequested(this.activity);

  @override
  List<Object?> get props => [activity];
}

class DeleteActivityRequested extends ActivityEvent {
  final String activityId;

  const DeleteActivityRequested(this.activityId);

  @override
  List<Object?> get props => [activityId];
}

class GetDetailActivityRequested extends ActivityEvent {
  final String activityId;

  const GetDetailActivityRequested(this.activityId);

  @override
  List<Object?> get props => [activityId];
}
