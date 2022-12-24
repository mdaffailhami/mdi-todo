import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/blocs/mark_task_as_active_bloc/mark_task_as_active_bloc.dart';
import 'package:mdi_todo/blocs/stream_tasks_bloc/stream_tasks_bloc.dart';
import 'package:mdi_todo/utils/show_snack_bar.dart';

import '../components/task_card.dart';
import '../components/task_form_dialog.dart';

class MyCompletedTaskListTab extends StatelessWidget {
  const MyCompletedTaskListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamTasksBloc, StreamTasksState>(
      builder: (context, state) {
        if (state is StreamTasksInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is StreamTasksFailure) {
          return const Center(
            child: Text('Failed to load tasks!'),
          );
        }

        if (state is StreamTasksSuccess) {
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

          return BlocListener<MarkTaskAsActiveBloc, MarkTaskAsActiveState>(
            listener: (context, state) {
              if (state is MarkTaskAsActiveSuccess) {
                showSnackBar(
                  context: context,
                  label: 'Task marked as active.',
                );
              }
            },
            child: ListView(
              padding: EdgeInsets.zero,
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
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
