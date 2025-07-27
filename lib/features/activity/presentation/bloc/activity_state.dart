import 'package:biznet_workforce_activity/features/activity/domain/entities/activity.dart';
import 'package:equatable/equatable.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final List<Activity> activities;

  const ActivityLoaded(this.activities);

  @override
  List<Object> get props => [activities];
}

class ActivityFailure extends ActivityState {
  final String message;

  const ActivityFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ActivityDetailLoaded extends ActivityState {
  final Activity activity;

  const ActivityDetailLoaded(this.activity);

  @override
  List<Object> get props => [activity];
}
