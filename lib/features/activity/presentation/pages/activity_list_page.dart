import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_event.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_state.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/pages/add_edit_activity_page.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/widgets/activity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({super.key});

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ActivityBloc>().add(LoadActivities());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biznet Workforce Activity')),
      body: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          if (state is ActivityLoading || state is ActivityInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ActivityLoaded) {
            if (state.activities.isEmpty) {
              return const Center(child: Text('No activities found.'));
            }
            return ListView.builder(
              itemCount: state.activities.length,
              itemBuilder: (context, index) {
                final activity = state.activities[index];
                return ActivityCard(activity: activity);
              },
            );
          }
          if (state is ActivityFailure) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Unexpected state'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddEditActivityPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
