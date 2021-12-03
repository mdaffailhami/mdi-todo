import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditTaskComponent extends StatefulWidget {
  String? title;

  EditTaskComponent({Key? key, this.title = ''}) : super(key: key);

  void Function()? onSaveButtonPressed;

  void Function()? onCancelButtonPressed;

  late TextEditingController titleInputController;

  @override
  State<EditTaskComponent> createState() => _EditTaskComponentState();
}

class _EditTaskComponentState extends State<EditTaskComponent> {
  @override
  void initState() {
    super.initState();
    widget.titleInputController = TextEditingController(text: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Your task'),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red[400],
            ),
            tooltip: 'Delete',
            onPressed: () {},
          ),
        ],
      ),
      content: TextField(
        controller: widget.titleInputController,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter task here..'),
      ),
      actions: [
        TextButton(
          onPressed: widget.onSaveButtonPressed,
          child: const Text('SAVE'),
        ),
        TextButton(
          onPressed: widget.onCancelButtonPressed,
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}
