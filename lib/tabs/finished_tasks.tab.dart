import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:mdi_todo/components/finished_task.component.dart';

final Localstore db = Localstore.instance;

class FinishedTasksTab extends StatefulWidget {
  const FinishedTasksTab({Key? key}) : super(key: key);

  @override
  State<FinishedTasksTab> createState() => _FinishedTasksTabState();
}

class _FinishedTasksTabState extends State<FinishedTasksTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.collection('finishedTasks').get(),
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
                final String taskId = tasks[index]['id'];
                final String taskTitle = tasks[index]['title'];

                return FinishedTaskComponent(
                  title: taskTitle,
                  onUnchecked: () async {
                    await Future.delayed(const Duration(milliseconds: 300));

                    await db
                        .collection('tasks')
                        .doc(taskId)
                        .set({'id': taskId, 'title': taskTitle});
                    db.collection('finishedTasks').doc(taskId).delete();

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
