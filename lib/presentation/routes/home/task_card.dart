import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/core/utils/format_date.dart';
import 'package:mdi_todo/core/utils/show_snack_bar.dart';
import 'package:mdi_todo/data/models/task.dart';
import 'package:mdi_todo/presentation/notifiers/tasks_notifier.dart';

class MyTaskCard extends StatefulWidget {
  final Task task;
  final Function()? onTap;

  const MyTaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  State<MyTaskCard> createState() => _MyTaskCardState();
}

class _MyTaskCardState extends State<MyTaskCard> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.task.completedAt != null;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(formatDate(widget.task.deadline)),
      trailing: Tooltip(
        message: checked ? 'Mark task as active' : 'Mark task as completed',
        child: Checkbox(
          value: checked,
          checkColor: Theme.of(context).colorScheme.surface,
          onChanged: (value) {
            if (value == null) return;

            if (!mounted) return;

            setState(() => checked = !checked);

            Future.delayed(const Duration(milliseconds: 300)).then((_) async {
              if (!context.mounted) return;

              if (value == true) {
                try {
                  await context
                      .read<TasksNotifier>()
                      .markTaskAsCompleted(widget.task);

                  if (context.mounted) {
                    showSnackBar(
                      context: context,
                      label: 'Mark task as completed success',
                    );
                  }
                } catch (e) {
                  setState(() => checked = !checked);

                  if (context.mounted) {
                    showSnackBar(
                      context: context,
                      label: 'Mark task as completed failed',
                    );
                  }
                }
              } else if (value == false) {
                try {
                  await context
                      .read<TasksNotifier>()
                      .markTaskAsActive(widget.task);

                  if (context.mounted) {
                    showSnackBar(
                      context: context,
                      label: 'Mark task as active success',
                    );
                  }
                } catch (e) {
                  setState(() => checked = !checked);

                  if (context.mounted) {
                    showSnackBar(
                      context: context,
                      label: 'Mark task as active failed',
                    );
                  }
                }
              }
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
