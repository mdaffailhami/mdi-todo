import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/core/request_state.dart';
import 'package:mdi_todo/presentation/components/task_card.dart';
import 'package:mdi_todo/presentation/components/task_form_dialog.dart';
import 'package:mdi_todo/presentation/providers/tasks_provider.dart';
import 'package:provider/provider.dart';

class MyActiveTaskListTab extends StatelessWidget {
  const MyActiveTaskListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, tasks, child) {
        if (tasks.state == RequestState.failed) {
          return const Center(
            child: Text('Failed to load tasks!'),
          );
        }

        if (tasks.state == RequestState.loaded) {
          if (tasks.value.isEmpty) {
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

          return ListView(
            padding: EdgeInsets.zero,
            children: tasks.value
                .map(
                  (task) => MyTaskCard(
                    task: task,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => MyTaskFormDialog.edit(task: task),
                      );
                    },
                  ),
                )
                .toList(),
          );
        }

        // Loading
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // return BlocBuilder<StreamTasksBloc, StreamTasksState>(
    //   builder: (context, state) {
    //     if (state is StreamTasksInProgress) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }

    //     if (state is StreamTasksFailure) {
    //       return const Center(
    //         child: Text('Failed to load tasks!'),
    //       );
    //     }

    //     if (state is StreamTasksSuccess) {
    //       if (state.activeTasks.isEmpty) {
    //         return Center(
    //           child: Text(
    //             'No active tasks',
    //             style: Theme.of(context)
    //                 .textTheme
    //                 .displaySmall!
    //                 .copyWith(fontSize: 18),
    //           ),
    //         );
    //       }

    //       return BlocListener<MarkTaskAsCompletedBloc,
    //           MarkTaskAsCompletedState>(
    //         listener: (context, state) {
    //           if (state is MarkTaskAsCompletedSuccess) {
    //             showSnackBar(
    //               context: context,
    //               label: 'Task marked as completed.',
    //             );
    //           }
    //         },
    //         child: ListView(
    //           padding: EdgeInsets.zero,
    //           children: state.sortedActiveTasks
    //               .map(
    //                 (task) => MyTaskCard(
    //                   task: task,
    //                   onTap: () {
    //                     showDialog(
    //                       context: context,
    //                       builder: (context) =>
    //                           MyTaskFormDialog.edit(task: task),
    //                     );
    //                   },
    //                 ),
    //               )
    //               .toList(),
    //         ),
    //       );
    //     }

    //     return const SizedBox.shrink();
    //   },
    // );
  }
}
