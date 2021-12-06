import 'package:flutter/material.dart';
import 'package:mdi_todo/components/add_task_button_component.dart';
import 'package:mdi_todo/components/task_card_component.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            TaskCardComponent(),
            TaskCardComponent(),
            TaskCardComponent(),
            TaskCardComponent(),
            TaskCardComponent(),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AddTaskButtonComponent(),
          ),
        )
      ],
    );
  }
}
