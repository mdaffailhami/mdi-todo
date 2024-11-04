import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/old/blocs/mark_task_as_completed_bloc/mark_task_as_completed_bloc.dart';
import 'package:mdi_todo/old/blocs/stream_tasks_bloc/stream_tasks_bloc.dart';
import 'package:mdi_todo/old/components/task_card.dart';
import 'package:mdi_todo/old/components/task_form_dialog.dart';
import 'package:mdi_todo/old/utils/show_snack_bar.dart';

class MyActiveTaskListTab extends StatelessWidget {
  const MyActiveTaskListTab({super.key});

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
          if (state.activeTasks.isEmpty) {
            return Center(
              child: Text(
                'No active tasks',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 18),
              ),
            );
          }

          return BlocListener<MarkTaskAsCompletedBloc,
              MarkTaskAsCompletedState>(
            listener: (context, state) {
              if (state is MarkTaskAsCompletedSuccess) {
                showSnackBar(
                  context: context,
                  label: 'Task marked as completed.',
                );
              }
            },
            child: ListView(
              padding: EdgeInsets.zero,
              children: state.sortedActiveTasks
                  .map(
                    (task) => MyTaskCard(
                      task: task,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              MyTaskFormDialog.edit(task: task),
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
