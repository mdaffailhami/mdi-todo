import 'package:flutter/material.dart';
import 'package:mdi_todo/models/task.model.dart';

class EditTaskComponent extends StatefulWidget {
  final TaskModel data;
  final void Function()? onCancelButtonPressed;
  final void Function(TaskModel data)? onSaveButtonPressed;
  final void Function()? onDeleteButtonPressed;

  const EditTaskComponent({
    Key? key,
    required this.data,
    this.onCancelButtonPressed,
    this.onSaveButtonPressed,
    this.onDeleteButtonPressed,
  }) : super(key: key);

  @override
  State<EditTaskComponent> createState() => _EditTaskComponentState();
}

class _EditTaskComponentState extends State<EditTaskComponent> {
  TextEditingController titleInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleInputController = TextEditingController(text: widget.data.title);
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
            onPressed: widget.onDeleteButtonPressed,
          ),
        ],
      ),
      content: TextField(
        controller: titleInputController,
        autofocus: false,
        decoration: const InputDecoration(hintText: 'Enter task here..'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onSaveButtonPressed!(
              TaskModel(
                id: widget.data.id,
                title: titleInputController.text,
              ),
            );
          },
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
