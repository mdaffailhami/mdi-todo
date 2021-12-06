import 'package:flutter/material.dart';
import 'package:mdi_todo/components/add_task_form_component.dart';

class AddTaskButtonComponent extends StatelessWidget {
  const AddTaskButtonComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return AddTaskFormComponent();
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
