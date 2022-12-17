import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/business_logic/cubits/tasks_cubit.dart';
import 'package:mdi_todo/data/models/task.dart';
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
        message: checked ? 'Turn it back to Active Tasks' : 'Set as completed',
        child: Checkbox(
          value: checked,
          checkColor: Theme.of(context).colorScheme.background,
          onChanged: (value) {
            if (value == null) return;

            setState(() => checked = !checked);
            Future.delayed(const Duration(milliseconds: 300)).then((_) {
              if (value == true) {
                BlocProvider.of<TasksCubit>(context)
                    .markTaskAsCompleted(widget.task);
              } else if (value == false) {
                BlocProvider.of<TasksCubit>(context)
                    .markTaskAsActive(widget.task);
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
