import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mdi_todo/components/delete_task_confirmation_component.dart';

class FinishedTaskPreviewComponent extends StatefulWidget {
  final String id;
  final String title;
  final String date;

  const FinishedTaskPreviewComponent({
    Key? key,
    required this.id,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  State<FinishedTaskPreviewComponent> createState() =>
      _FinishedTaskPreviewComponentState();
}

class _FinishedTaskPreviewComponentState
    extends State<FinishedTaskPreviewComponent> {
  String titleInputValue = '';
  String dateInputValue = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    titleInputValue = widget.title;
    dateInputValue = widget.date;
  }

  void onSetDateButtonPressed() {}

  void onDeleteTaskButtonPressed() {
    showDialog(
      context: context,
      builder: (_) {
        return const DeleteTaskConfirmationComponent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Your finished task'),
          IconButton(
            onPressed: onDeleteTaskButtonPressed,
            icon: const Icon(Icons.delete, color: Colors.red),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            readOnly: true,
            initialValue: titleInputValue,
            autofocus: false,
            decoration: const InputDecoration(hintText: 'Enter task here..'),
            onChanged: (String value) {
              titleInputValue = value;
            },
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat.yMMMMd().format(DateTime.parse(dateInputValue))),
              ElevatedButton(
                onPressed: onSetDateButtonPressed,
                child: const Icon(Icons.date_range),
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CLOSE'),
        ),
      ],
    );
  }
}
