import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/business_logic/cubits/tasks_cubit.dart';
import 'package:mdi_todo/data/models/task.dart';
import 'package:mdi_todo/utils/format_date.dart';

enum TaskFormDialogType {
  add,
  edit,
  detail,
}

class MyTaskFormDialog extends StatefulWidget {
  final TaskFormDialogType type;
  final Task? task;

  const MyTaskFormDialog.add({super.key})
      : type = TaskFormDialogType.add,
        task = null;

  const MyTaskFormDialog.edit({
    super.key,
    required this.task,
  }) : type = TaskFormDialogType.edit;

  const MyTaskFormDialog.detail({
    super.key,
    required this.task,
  }) : type = TaskFormDialogType.detail;

  @override
  State<MyTaskFormDialog> createState() => _MyTaskFormDialogState();
}

class _MyTaskFormDialogState extends State<MyTaskFormDialog> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  DateTime deadline = DateTime.now();

  @override
  void initState() {
    super.initState();
    final type = widget.type;

    if (type == TaskFormDialogType.edit || type == TaskFormDialogType.detail) {
      name = widget.task!.name;
      deadline = widget.task!.deadline;
    }
  }

  Future<void> addTask() async {
    if (formKey.currentState!.validate() == false) throw Exception();

    final task = Task(name: name, deadline: deadline);
    BlocProvider.of<TasksCubit>(context).addTask(task);
  }

  Future<void> deleteTask() async {
    BlocProvider.of<TasksCubit>(context).deleteTask(widget.task!);
  }

  Future<void> editTask() async {
    if (formKey.currentState!.validate() == false) throw Exception();

    BlocProvider.of<TasksCubit>(context).editTask(
      widget.task!.copyWith(name: name, deadline: deadline),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 14, 0),
      title: () {
        if (type == TaskFormDialogType.add) {
          return Text(
            'Add new task',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          );
        }
        if (type == TaskFormDialogType.edit ||
            type == TaskFormDialogType.detail) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type == TaskFormDialogType.edit
                    ? 'Edit your task'
                    : 'Task completed',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Delete task',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => deleteTask().then((value) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                      content: const Text(
                          'Are you sure you want to delete this task?'),
                    ),
                  );
                },
                tooltip: 'Delete task',
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          );
        }
      }(),
      actions: () {
        List<Widget> children = [];

        Future<void> Function() onPressed = () async {};
        String text = '';

        if (type == TaskFormDialogType.add) {
          onPressed = addTask;
          text = 'Add';
        }
        if (type == TaskFormDialogType.edit) {
          onPressed = editTask;
          text = 'Save';
        }
        if (type == TaskFormDialogType.detail) {
          children.add(TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ));

          return children;
        }

        children.addAll([
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => onPressed()
                .then((value) => Navigator.of(context).pop())
                .catchError((_, __) {}),
            child: Text(text),
          ),
        ]);

        return children;
      }(),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
              child: TextFormField(
                onChanged: (value) => name = value,
                readOnly: type == TaskFormDialogType.detail ? true : false,
                autofocus: type == TaskFormDialogType.add ? true : false,
                initialValue: name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                decoration: InputDecoration(
                  hintText: type == TaskFormDialogType.detail
                      ? ''
                      : 'Type your task here..',
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Task name is required!'
                    : null,
                onFieldSubmitted: (_) {
                  if (type == TaskFormDialogType.add) {
                    addTask()
                        .then((value) => Navigator.of(context).pop())
                        .catchError((_, __) {});
                  }
                  if (type == TaskFormDialogType.edit) {
                    editTask()
                        .then((value) => Navigator.of(context).pop())
                        .catchError((_, __) {});
                  }
                },
              ),
            ),
            const SizedBox(height: 17),
            TextButton(
              onPressed: () async {
                if (type != TaskFormDialogType.detail) {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: deadline,
                    firstDate: DateTime(DateTime.now().year - 100),
                    lastDate: DateTime(DateTime.now().year + 100),
                    helpText: 'Select Date',
                    cancelText: 'Cancel',
                    confirmText: 'Set',
                  );

                  if (pickedDate != null) {
                    setState((() => deadline = pickedDate));
                  }
                }
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDate(deadline)),
                  Tooltip(
                    message:
                        type == TaskFormDialogType.detail ? '' : 'Set deadline',
                    child: Icon(
                      Icons.date_range,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
