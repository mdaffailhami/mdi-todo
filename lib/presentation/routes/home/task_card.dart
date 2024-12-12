import 'package:flutter/material.dart';
import 'package:mdi_todo/core/utils/format_date.dart';
import 'package:mdi_todo/data/models/task.dart';

import 'task_checkbox.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onTap});

  final Task task;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 18),
      ),
      subtitle: Text(
        formatDate(task.deadline),
        style: const TextStyle(
            color: Color.fromARGB(255, 134, 134, 134), fontSize: 16),
      ),
      trailing: TaskCheckbox(task: task, isChecked: task.completedAt != null),
      onTap: () => onTap(),
    );
  }
}
