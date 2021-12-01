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
  getAllTasks() {
    // setTask(title: 'Aowkwkw');
    // setTask(title: 'UWUWUWU');
    return db.collection('tasks').get();
  }

  setTask({String? id, required String title}) async {
    id ??= DateTime.now().millisecondsSinceEpoch.toString();

    return await db.collection('tasks').doc(id).set({'id': id, 'title': title});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MDI Todo'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Task',
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: getAllTasks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('LOADING..');
          } else {
            if (!snapshot.hasData) {
              return const Text('TASK EMPTY!');
            } else {
              List tasks = [];
              snapshot.data.forEach((String key, dynamic value) {
                tasks.add(value);
              });

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return TaskComponent(tasks[index]['title']);
                },
              );
            }
          }
        },
      ),
    );
  }
}
