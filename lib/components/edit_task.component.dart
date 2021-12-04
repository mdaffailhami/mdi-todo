import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late DateTime dateInputValue;
  late TextEditingController titleInputController;

  @override
  void initState() {
    super.initState();
    dateInputValue = DateTime.parse(widget.data.date);
    titleInputController = TextEditingController(text: widget.data.title);
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('MMMM dd, yyyy').format(dateInputValue).toString();

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleInputController,
            autofocus: false,
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
                    initialDate: dateInputValue,
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
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onSaveButtonPressed!(
              TaskModel(
                  id: widget.data.id,
                  title: titleInputController.text,
                  date: dateInputValue.toString()),
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
