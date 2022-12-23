import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/blocs/edit_task_bloc/edit_task_bloc.dart';
import 'package:mdi_todo/models/task.dart';
import 'package:mdi_todo/utils/format_date.dart';

class MyTaskCard extends StatefulWidget {
  final Task task;
  final Function()? onTap;
  final Function()? onChecked;
  final Function()? onUnchecked;

  const MyTaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onChecked,
    this.onUnchecked,
  });

  @override
  State<MyTaskCard> createState() => _MyTaskCardState();
}

class _MyTaskCardState extends State<MyTaskCard> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.task.completed;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.task.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(formatDate(widget.task.deadline)),
      trailing: Tooltip(
        message: checked ? 'Mark as active' : 'Mark as completed',
        child: Checkbox(
          value: checked,
          checkColor: Theme.of(context).colorScheme.background,
          onChanged: (value) {
            if (value == null) return;

            setState(() => checked = !checked);
            Future.delayed(const Duration(milliseconds: 300)).then((_) {
              final newTask = Task.from(widget.task);

              if (value == true) {
                newTask.completed = true;
                newTask.completionDateTime = DateTime.now();

                BlocProvider.of<EditTaskBloc>(context).editTask(newTask);
              } else if (value == false) {
                newTask.completed = false;
                newTask.completionDateTime = null;

                BlocProvider.of<EditTaskBloc>(context).editTask(newTask);
              }
              checked = !checked;
            });
          },
        ),
      ),
      onTap: () {
        if (widget.onTap != null) widget.onTap!();
      },
    );
  }
}
