import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:mdi_todo/components/add_task.component.dart';
import 'package:mdi_todo/components/task.component.dart';

final Localstore db = Localstore.instance;

class TaskListTab extends StatefulWidget {
  const TaskListTab({Key? key}) : super(key: key);

  @override
  _TaskListTabState createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  Future<Map<String, dynamic>?> getAllTasks() {
    return db.collection('tasks').get();
  }

  Future<dynamic> setTask({String? id, required String title}) {
    id ??= DateTime.now().millisecondsSinceEpoch.toString();

    return db.collection('tasks').doc(id).set({'id': id, 'title': title});
  }

  Future<dynamic> deleteTask({required String id}) {
    return db.collection('tasks').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: getAllTasks(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                // Jika tidak ada tasks
                return Center(
                  child: Text(
                    'No tasks!',
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
                    return TaskComponent(
                      title: tasks[index]['title'],
                      onChecked: () async {
                        await Future.delayed(const Duration(milliseconds: 250));

                        deleteTask(id: tasks[index]['id']);

                        // refresh task list
                        setState(() {});
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
                      onSubmit: (Map<String, dynamic> value) async {
                        await setTask(title: value['title']);

                        Navigator.of(context).pop();

                        // Refresh task list
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
