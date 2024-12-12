import 'package:flutter/material.dart';
import 'package:mdi_todo/presentation/notifiers/tasks_notifier.dart';
import 'package:mdi_todo/presentation/routes/home/task_card.dart';
import 'package:mdi_todo/presentation/routes/home/task_form_dialog.dart';
import 'package:provider/provider.dart';

class MyCompletedTaskListTab extends StatelessWidget {
  const MyCompletedTaskListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksNotifier>(
      builder: (context, notifier, child) {
        if (notifier.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (notifier.error != null) {
          // return const Center(child: Text('Failed to load tasks!'));
          return Center(child: Text(notifier.error.toString()));
        }

        // Filter only completed tasks to show
        final completedTasks =
            notifier.value.where((task) => task.completedAt != null).toList();

        // Sort tasks by completed datetime (descending)
        completedTasks.sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

        if (completedTasks.isEmpty) {
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
          padding: EdgeInsets.zero,
          children: [
            ...completedTasks.map((task) {
              return TaskCard(
                task: task,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => MyTaskFormDialog.detail(task: task),
                  );
                },
              );
            }),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }
}
