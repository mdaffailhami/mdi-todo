import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:mdi_todo/components/add_task.component.dart';
import 'package:mdi_todo/components/edit_task.component.dart';
import 'package:mdi_todo/components/task.component.dart';

final Localstore db = Localstore.instance;

class TaskListTab extends StatefulWidget {
  const TaskListTab({Key? key}) : super(key: key);

  @override
  _TaskListTabState createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: db.collection('tasks').get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                // Jika tidak ada tasks
                return Center(
                  child: Text(
                    'No tasks',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.grey),
                  ),
                );
              } else {
                List tasks = [];
                snapshot.data.forEach((String key, dynamic value) {
                  tasks.add(value);
                });

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String taskId = tasks[index]['id'];
                    final String taskTitle = tasks[index]['title'];

                    return TaskComponent(
                      title: taskTitle,
                      onChecked: () async {
                        await Future.delayed(const Duration(milliseconds: 300));

                        await db
                            .collection('finishedTasks')
                            .doc(taskId)
                            .set({'id': taskId, 'title': taskTitle});
                        db.collection('tasks').doc(taskId).delete();

                        setState(() {});
                      },
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final EditTaskComponent editTaskComponent =
                                EditTaskComponent(
                              title: taskTitle,
                            );

                            editTaskComponent.onSaveButtonPressed = () {
                              final String titleInputValue =
                                  editTaskComponent.titleInputController.text;

                              // Edit task
                              db.collection('tasks').doc(taskId).set(
                                {
                                  'id': taskId,
                                  'title': titleInputValue,
                                },
                              );

                              Navigator.of(context).pop();
                              setState(() {});
                            };

                            editTaskComponent.onCancelButtonPressed = () {
                              Navigator.of(context).pop();
                            };

                            editTaskComponent.onDeleteButtonPressed = () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Are you sure you want to delete this task?'),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          db
                                              .collection('tasks')
                                              .doc(taskId)
                                              .delete();

                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();

                                          setState(() {});
                                        },
                                        child: const Text('Yes'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            };
                            return editTaskComponent;
                          },
                        );
                      },
                    );
                  },
                );
              }
            }
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FloatingActionButton(
              tooltip: 'Add Task',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final AddTaskComponent addTaskComponent =
                        AddTaskComponent();

                    addTaskComponent.onAddButtonPressed = () async {
                      final String taskId =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      final String titleInputValue =
                          addTaskComponent.titleInputController.text;

                      await db.collection('tasks').doc(taskId).set(
                        {'id': taskId, 'title': titleInputValue},
                      );

                      Navigator.of(context).pop();
                      setState(() {});
                    };

                    addTaskComponent.onCancelButtonPressed = () {
                      Navigator.of(context).pop();
                    };

                    return addTaskComponent;
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
