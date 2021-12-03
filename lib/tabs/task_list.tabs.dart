import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:mdi_todo/components/add_task.component.dart';
import 'package:mdi_todo/components/delete_task_confirmation.component.dart';
import 'package:mdi_todo/components/edit_task.component.dart';
import 'package:mdi_todo/components/task.component.dart';
import 'package:mdi_todo/model/task.model.dart';

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
                // Jika data == null
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
                // Jika data != null
                List tasks = [];
                snapshot.data.forEach((String key, dynamic value) {
                  tasks.add(value);
                });

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    final TaskModel task = TaskModel(
                        id: tasks[index]['id'], title: tasks[index]['title']);

                    return TaskComponent(
                      title: task.title,
                      onChecked: () async {
                        await Future.delayed(const Duration(milliseconds: 300));

                        // Hapus task di collection "finishedTask"
                        await db
                            .collection('finishedTasks')
                            .doc(task.id)
                            .set({'id': task.id, 'title': task.title});

                        // Tambah task di collection "tasks"
                        db.collection('tasks').doc(task.id).delete();

                        // Refresh tasks
                        setState(() {});
                      },
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditTaskComponent(
                              data: TaskModel(id: task.id, title: task.title),
                              onCancelButtonPressed: () {
                                Navigator.of(context).pop();
                              },
                              onSaveButtonPressed: (TaskModel data) {
                                // Edit task
                                db.collection('tasks').doc(task.id).set(
                                  {
                                    'id': data.id,
                                    'title': data.title,
                                  },
                                );

                                // Close EditTaskComponent
                                Navigator.of(context).pop();

                                // Refresh tasks
                                setState(() {});
                              },
                              onDeleteButtonPressed: () {
                                // Show delete confirmation
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DeleteTaskConfirmation(
                                      onNoButtonPressed: () {
                                        // Close Delete Confirmation
                                        Navigator.of(context).pop();
                                      },
                                      onYesButtonPressed: () {
                                        // Delete task
                                        db
                                            .collection('tasks')
                                            .doc(task.id)
                                            .delete();

                                        // Close Delete Confirmation
                                        Navigator.of(context).pop();

                                        // Close EditTaskComponent
                                        Navigator.of(context).pop();

                                        // Refresh tasks
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              },
                            );
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
                    return AddTaskComponent(
                      onCancelButtonPressed: () {
                        Navigator.of(context).pop();
                      },
                      onAddButtonPressed: (TaskModel data) async {
                        await db.collection('tasks').doc(data.id).set(
                          {'id': data.id, 'title': data.title},
                        );

                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    );
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
