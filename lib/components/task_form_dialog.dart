import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/blocs/add_task_bloc/add_task_bloc.dart';
import 'package:mdi_todo/blocs/delete_task_bloc/delete_task_bloc.dart';
import 'package:mdi_todo/blocs/edit_task_bloc/edit_task_bloc.dart';
import 'package:mdi_todo/models/task.dart';
import 'package:mdi_todo/utils/format_date.dart';
import 'package:mdi_todo/utils/show_snack_bar.dart';

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

  Future<void> addTaskButtonPressed() async {
    if (formKey.currentState!.validate() == false) return;

    BlocProvider.of<AddTaskBloc>(context).addTask(
      name: name,
      deadline: deadline,
    );
  }

  Future<void> deleteTaskButtonPressed() async {
    BlocProvider.of<DeleteTaskBloc>(context).deleteTask(widget.task!);
  }

  Future<void> editTaskButtonPressed() async {
    if (formKey.currentState!.validate() == false) return;

    BlocProvider.of<EditTaskBloc>(context).editTask(
      widget.task!,
      name: name,
      deadline: deadline,
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;

    return MultiBlocListener(
      listeners: [
        BlocListener<AddTaskBloc, AddTaskState>(
          listener: (context, state) {
            if (state is AddTaskSuccess) {
              showSnackBar(context: context, label: 'Task added.');
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        ),
        BlocListener<DeleteTaskBloc, DeleteTaskState>(
          listener: (context, state) {
            if (state is DeleteTaskSuccess) {
              showSnackBar(context: context, label: 'Task deleted.');
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        ),
        BlocListener<EditTaskBloc, EditTaskState>(
          listener: (context, state) {
            if (state is EditTaskSuccess) {
              showSnackBar(context: context, label: 'Task edited.');
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        ),
      ],
      child: AlertDialog(
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
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
                            onPressed: deleteTaskButtonPressed,
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
            onPressed = addTaskButtonPressed;
            text = 'Add';
          }
          if (type == TaskFormDialogType.edit) {
            onPressed = editTaskButtonPressed;
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
              onPressed: () => onPressed(),
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
                      addTaskButtonPressed();
                    }
                    if (type == TaskFormDialogType.edit) {
                      editTaskButtonPressed();
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 12,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(formatDate(deadline)),
                    ),
                    Tooltip(
                      message: type == TaskFormDialogType.detail
                          ? ''
                          : 'Set deadline',
                      child: Icon(
                        Icons.date_range,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
