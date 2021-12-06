import 'package:flutter/material.dart';
import 'package:mdi_todo/components/finished_task_card_component.dart';

class FinishedTasksPage extends StatelessWidget {
  const FinishedTasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FinishedTaskCardComponent(),
        FinishedTaskCardComponent(),
        FinishedTaskCardComponent(),
      ],
    );
  }
}
