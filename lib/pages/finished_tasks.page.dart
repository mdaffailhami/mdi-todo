import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:mdi_todo/components/finished_task.component.dart';
import 'package:mdi_todo/localstore_collections/finished_tasks.localstore_collection.dart';
import 'package:mdi_todo/localstore_collections/tasks.localstore_collection.dart';
import 'package:mdi_todo/models/task.model.dart';

final Localstore db = Localstore.instance;

class FinishedTasksPage extends StatefulWidget {
  const FinishedTasksPage({Key? key}) : super(key: key);

  @override
  State<FinishedTasksPage> createState() => _FinishedTasksPageState();
}

class _FinishedTasksPageState extends State<FinishedTasksPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: finishedTasksLocalstoreCollection.get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No tasks finished',
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
                final TaskModel task = TaskModel(
                    id: tasks[index]['id'],
                    title: tasks[index]['title'],
                    date: tasks[index]['date']);

                return FinishedTaskComponent(
                  title: task.title,
                  date: task.date,
                  onUnchecked: () async {
                    await Future.delayed(const Duration(milliseconds: 300));

                    await tasksLocalstoreCollection
                        .doc(task.id)
                        .set(task.toMap());

                    finishedTasksLocalstoreCollection.doc(task.id).delete();

                    setState(() {});
                  },
                );
              },
            );
          }
        }
      },
    );
  }
}
