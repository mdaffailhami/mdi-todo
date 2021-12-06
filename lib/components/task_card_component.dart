import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mdi_todo/components/edit_task_form_component.dart';

class TaskCardComponent extends StatefulWidget {
  final String id;
  final String title;
  final String date;

  const TaskCardComponent({
    Key? key,
    required this.id,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  State<TaskCardComponent> createState() => _TaskCardComponentState();
}

class _TaskCardComponentState extends State<TaskCardComponent> {
  bool? isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = false;
  }

  void onTaskTapped() {
    showDialog(
      context: context,
      builder: (_) {
        return EditTaskFormComponent(
          id: widget.id,
          title: widget.title,
          date: widget.date,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: isChecked,
          shape: const CircleBorder(),
          onChanged: (bool? value) {
            setState(() {
              isChecked = value;
            });
          },
        ),
        title: Text(widget.title),
        subtitle: Text(DateFormat.yMMMMd().format(DateTime.parse(widget.date))),
        onTap: onTaskTapped,
      ),
    );
  }
}
