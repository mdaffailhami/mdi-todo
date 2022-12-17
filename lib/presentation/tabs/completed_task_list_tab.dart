import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/business_logic/cubits/tasks_cubit.dart';

import '../components/task_card.dart';
import '../components/task_form_dialog.dart';

class MyCompletedTaskListTab extends StatelessWidget {
  const MyCompletedTaskListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        if (state is TasksLoadInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is TasksLoadFailure) {
          return const Center(
            child: Text('Failed to load tasks!'),
          );
        }

        if (state is TasksLoadSuccess) {
          if (state.completedTasks.isEmpty) {
            return Center(
              child: Text(
                'No completed tasks',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 18),
              ),
            );
          }

          return ListView(
            children: state.sortedCompletedTasks
                .map(
                  (task) => MyTaskCard(
                    task: task,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            MyTaskFormDialog.detail(task: task),
                      );
                    },
                  ),
                )
                .toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
