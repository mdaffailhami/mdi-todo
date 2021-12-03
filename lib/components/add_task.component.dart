import 'package:flutter/material.dart';

class AddTaskComponent extends StatelessWidget {
  final void Function(Map<String, dynamic> value)? onSubmit;

  AddTaskComponent({Key? key, this.onSubmit}) : super(key: key);

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
              final Map<String, dynamic> value = {
                'title': titleInputController.text
              };
              onSubmit!(value);
            },
            child: const Text('ADD')),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}
