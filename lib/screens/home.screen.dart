import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:mdi_todo/components/task.component.dart';

final Localstore db = Localstore.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String addTaskInputValue = '';

  getAllTasks() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return db.collection('tasks').get();
  }

  setTask({String? id, required String title}) async {
    id ??= DateTime.now().millisecondsSinceEpoch.toString();

    return await db.collection('tasks').doc(id).set({'id': id, 'title': title});
  }

  deleteTask({required String id}) {
    db.collection('tasks').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MDI Todo'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Task',
        onPressed: () {
          addTaskInputValue = '';
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add new task'),
                content: TextField(
                  autofocus: true,
                  decoration:
                      const InputDecoration(hintText: 'Enter task here..'),
                  onChanged: (value) => addTaskInputValue = value,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        setTask(title: addTaskInputValue);
                        Navigator.of(context).pop();

                        // Refresh task list
                        setState(() {});
                      },
                      child: const Text('ADD')),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('CANCEL'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
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
                  style: Theme.of(context).textTheme.headline6,
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
    );
  }
}
