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
            TaskCardComponent(
              id: '138419561801',
              title: 'Mana saia tau saia kan ikan',
              date: DateTime.now().toString(),
            ),
            TaskCardComponent(
              id: '138419561801',
              title: 'Mana saia tau saia kan ikan',
              date: DateTime.now().toString(),
            ),
            TaskCardComponent(
              id: '138419561801',
              title: 'Mana saia tau saia kan ikan',
              date: DateTime.now().toString(),
            ),
          ],
        ),
        const Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: AddTaskButtonComponent(),
          ),
        )
      ],
    );
  }
}
