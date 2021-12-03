import 'package:flutter/material.dart';

class EditTaskComponent extends StatefulWidget {
  final String? title;
  final void Function(Map<String, dynamic> value)? onSubmit;

  const EditTaskComponent({Key? key, this.title, this.onSubmit})
      : super(key: key);

  @override
  State<EditTaskComponent> createState() => _EditTaskComponentState();
}

class _EditTaskComponentState extends State<EditTaskComponent> {
  late TextEditingController titleInputController;

  @override
  void initState() {
    super.initState();
    titleInputController = TextEditingController(text: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit your task'),
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
              widget.onSubmit!(value);
            },
            child: const Text('SAVE')),
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
