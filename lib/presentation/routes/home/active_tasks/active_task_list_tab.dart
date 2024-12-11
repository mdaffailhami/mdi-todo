import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:mdi_todo/core/dependencies.dart';
import 'package:mdi_todo/core/utils/format_date.dart';
import 'package:mdi_todo/data/repositories/tasks_repository.dart';
import 'package:mdi_todo/presentation/notifiers/tasks_notifier.dart';
import 'package:mdi_todo/presentation/routes/home/task_card.dart';
import 'package:mdi_todo/presentation/routes/home/task_form_dialog.dart';
import 'package:provider/provider.dart';

class MyActiveTaskListTab extends StatelessWidget {
  const MyActiveTaskListTab({super.key});

  @override
  Widget build(BuildContext context) {
    void onLaunchViaAppWidget(Uri? data) {
      if (data == null) return;

      // If not homewidget://com.mdi.mdi_todo, then return
      if (data.scheme != 'homewidget') return;
      if (data.host != 'com.mdi.mdi_todo') return;

      final paths = data.pathSegments;
      if (paths.isEmpty) return;

      // mdi-todo://open-task
      if (paths[0] == 'open-task') {
        // mdi-todo://open-task/<task_id>
        if (paths.length == 2) {
          final taskId = paths[1];

          if (!context.mounted) return;

          final task = context.read<TasksNotifier>().getById(taskId);

          if (task == null) return;

          // Pop all routes first before showing the dialog
          while (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          // Show task form dialog
          showDialog(
            context: context,
            builder: (context) {
              return MyTaskFormDialog.edit(task: task);
            },
          );
        }
      }
    }

    // Register callback that is called when the app is launched via app widget by clicking a task
    HomeWidget.initiallyLaunchedFromHomeWidget().then(onLaunchViaAppWidget);
    HomeWidget.widgetClicked.listen(onLaunchViaAppWidget);

    return Consumer<TasksNotifier>(
      builder: (context, notifier, child) {
        if (notifier.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (notifier.error != null) {
          // return const Center(child: Text('Failed to load tasks!'));
          return Center(child: Text(notifier.error.toString()));
        }

        // Filter only active tasks to show
        final activeTasks =
            notifier.value.where((task) => task.completedAt == null).toList();

        // Sort tasks by deadline (ascending)
        activeTasks.sort((a, b) => a.deadline.compareTo(b.deadline));

        // Save and update active tasks widget
        locator<TasksRepository>().saveAndUpdateActiveTasksWidget(activeTasks);

        if (activeTasks.isEmpty) {
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
          children: [
            ...activeTasks.map((task) {
              return TaskCard(
                task: task,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => MyTaskFormDialog.edit(task: task),
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
