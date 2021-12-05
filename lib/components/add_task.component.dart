import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mdi_todo/models/task.model.dart';

class AddTaskComponent extends StatefulWidget {
  final void Function()? onCancelButtonPressed;
  final void Function(TaskModel data)? onAddButtonPressed;

  const AddTaskComponent({
    Key? key,
    this.onCancelButtonPressed,
    this.onAddButtonPressed,
  }) : super(key: key);

  @override
  State<AddTaskComponent> createState() => _AddTaskComponentState();
}

class _AddTaskComponentState extends State<AddTaskComponent> {
  DateTime dateInputValue = DateTime.now();
  final TextEditingController titleInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('MMMM dd, yyyy').format(dateInputValue).toString();

    return AlertDialog(
      title: const Text('Add new task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleInputController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter task here..'),
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Expanded(
                child: Text(formattedDate),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                  );

                  if (date == null) {
                    // Jika di-cancel
                    return;
                  } else {
                    setState(() {
                      dateInputValue = date;
                    });
                  }
                },
                child: const Icon(Icons.date_range),
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onAddButtonPressed!(
              TaskModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleInputController.text,
                date: dateInputValue.toString(),
              ),
            );
          },
          child: const Text('ADD'),
        ),
        TextButton(
          onPressed: widget.onCancelButtonPressed,
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}
