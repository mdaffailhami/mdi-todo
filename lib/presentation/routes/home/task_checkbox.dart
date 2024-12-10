import 'package:flutter/material.dart';
import 'package:mdi_todo/data/models/task.dart';
import 'package:mdi_todo/presentation/notifiers/tasks_notifier.dart';
import 'package:provider/provider.dart';

class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({
    super.key,
    required this.task,
    required this.isChecked,
    this.onChanged,
  });

  final Task task;
  final bool isChecked;
  final void Function()? onChanged;

  @override
  Widget build(BuildContext context) {
    final isCheckedState = ValueNotifier<bool>(isChecked);

    return ValueListenableBuilder(
      valueListenable: isCheckedState,
      builder: (context, isChecked, child) {
        return Tooltip(
          message: isChecked ? 'Mark task as active' : 'Mark task as completed',
          child: Checkbox(
            value: isChecked,
            checkColor: Theme.of(context).colorScheme.surface,
            onChanged: (value) {
              if (value == null) return;

              if (!context.mounted) return;

              isCheckedState.value = !isCheckedState.value;

              Future.delayed(const Duration(milliseconds: 300)).then((_) async {
                if (!context.mounted) return;

                if (value == true) {
                  await context
                      .read<TasksNotifier>()
                      .markTaskAsCompleted(context, task);
                } else if (value == false) {
                  await context
                      .read<TasksNotifier>()
                      .markTaskAsActive(context, task);
                }

                // Fix bug below task got checked
                isCheckedState.value = !isCheckedState.value;

                if (onChanged != null) onChanged!();
              });
            },
          ),
        );
      },
    );
  }
}
