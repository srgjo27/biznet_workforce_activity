import 'dart:async';

import 'package:biznet_workforce_activity/features/activity/domain/usecases/manage_activity.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_event.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final GetActivities _getActivities;
  final AddActivity _addActivity;
  final UpdateActivity _updateActivity;
  final DeleteActivity _deleteActivity;
  final GetDetailActivity _getDetailActivity;
  StreamSubscription? _activitiesSubscription;

  ActivityBloc({
    required GetActivities getActivities,
    required AddActivity addActivity,
    required UpdateActivity updateActivity,
    required DeleteActivity deleteActivity,
    required GetDetailActivity getDetailActivity,
  }) : _getActivities = getActivities,
       _addActivity = addActivity,
       _updateActivity = updateActivity,
       _deleteActivity = deleteActivity,
       _getDetailActivity = getDetailActivity,
       super(ActivityInitial()) {
    on<LoadActivities>(_onLoadActivities);
    on<ActivitiesUpdated>(_onActivitiesUpdated);
    on<AddActivityRequested>(_onAddActivity);
    on<UpdateActivityRequested>(_onUpdateActivity);
    on<DeleteActivityRequested>(_onDeleteActivity);
    on<GetDetailActivityRequested>(_onGetDetailActivity);
  }

  void _onLoadActivities(LoadActivities event, Emitter<ActivityState> emit) {
    emit(ActivityLoading());
    _activitiesSubscription?.cancel();
    _activitiesSubscription = _getActivities().listen(
      (activities) => add(ActivitiesUpdated(activities)),
      onError: (error) => emit(ActivityFailure(error.toString())),
    );
  }

  void _onActivitiesUpdated(
    ActivitiesUpdated event,
    Emitter<ActivityState> emit,
  ) {
    emit(ActivityLoaded(event.activities));
  }

  Future<void> _onAddActivity(
    AddActivityRequested event,
    Emitter<ActivityState> emit,
  ) async {
    try {
      await _addActivity(event.activity);
    } catch (e) {
      emit(ActivityFailure(e.toString()));
    }
  }

  Future<void> _onUpdateActivity(
    UpdateActivityRequested event,
    Emitter<ActivityState> emit,
  ) async {
    try {
      await _updateActivity(event.activity);
    } catch (e) {
      emit(ActivityFailure(e.toString()));
    }
  }

  Future<void> _onDeleteActivity(
    DeleteActivityRequested event,
    Emitter<ActivityState> emit,
  ) async {
    try {
      await _deleteActivity(event.activityId);
    } catch (e) {
      emit(ActivityFailure(e.toString()));
    }
  }

  Future<void> _onGetDetailActivity(
    GetDetailActivityRequested event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    try {
      final activity = await _getDetailActivity(event.activityId);

      if (activity != null) {
        emit(ActivityDetailLoaded(activity));
      }
    } catch (e) {
      emit(ActivityFailure(e.toString()));
    }
  }
}
