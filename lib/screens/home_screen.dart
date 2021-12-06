import 'package:flutter/material.dart';
import 'package:mdi_todo/pages/finished_tasks_page.dart';
import 'package:mdi_todo/pages/task_list_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('MDI Todo'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.list),
                text: 'Task List',
              ),
              Tab(
                icon: Icon(Icons.fact_check_outlined),
                text: 'Finished Tasks',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TaskListPage(),
            FinishedTasksPage(),
          ],
        ),
      ),
    );
  }
}
