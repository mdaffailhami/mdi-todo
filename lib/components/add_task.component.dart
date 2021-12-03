import 'package:flutter/material.dart';
import 'package:mdi_todo/models/task.model.dart';

class AddTaskComponent extends StatelessWidget {
  final void Function()? onCancelButtonPressed;
  final void Function(TaskModel data)? onAddButtonPressed;

  AddTaskComponent({
    Key? key,
    this.onCancelButtonPressed,
    this.onAddButtonPressed,
  }) : super(key: key);

  final TextEditingController titleInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new task'),
      content: TextField(
        controller: titleInputController,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter task here..'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onAddButtonPressed!(
              TaskModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleInputController.text,
              ),
            );
          },
          child: const Text('ADD'),
        ),
        TextButton(
          onPressed: onCancelButtonPressed,
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}
