import 'package:flutter/material.dart';
import 'package:mdi_todo/core/utils/show_snack_bar.dart';
import 'package:mdi_todo/data/models/task.dart';
import 'package:mdi_todo/presentation/notifiers/tasks_notifier.dart';
import 'package:provider/provider.dart';

class DeleteTaskConfirmationDialog extends StatelessWidget {
  const DeleteTaskConfirmationDialog({
    super.key,
    required this.task,
    required this.onTaskDeleted,
  });

  final Task task;
  final void Function() onTaskDeleted;

  @override
  Widget build(BuildContext context) {
    Future<void> onDeleteTaskButtonPressed() async {
      try {
        await context.read<TasksNotifier>().delete(task);

        if (context.mounted) {
          showSnackBar(context: context, label: 'Delete task success');
        }
      } catch (e) {
        if (context.mounted) {
          showSnackBar(context: context, label: e.toString());
        }
      } finally {
        onTaskDeleted();
      }
    }

    return AlertDialog(
      title: Text(
        'Delete task',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onDeleteTaskButtonPressed,
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
      content: const Text('Are you sure you want to delete this task?'),
    );
  }
}
