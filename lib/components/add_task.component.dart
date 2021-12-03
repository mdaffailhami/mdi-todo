import 'package:flutter/material.dart';

class AddTaskComponent extends StatelessWidget {
  void Function()? onAddButtonPressed;
  void Function()? onCancelButtonPressed;

  AddTaskComponent(
      {Key? key, this.onAddButtonPressed, this.onCancelButtonPressed})
      : super(key: key);

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
          onPressed: onAddButtonPressed,
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
