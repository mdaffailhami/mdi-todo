import 'package:flutter/cupertino.dart';
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
      ),
      subtitle: Text(formatDate(task.deadline)),
      trailing: TaskCheckbox(task: task, isChecked: task.completedAt != null),
      onTap: () => onTap(),
    );
  }
}
