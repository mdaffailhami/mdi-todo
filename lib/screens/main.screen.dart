import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:mdi_todo/pages/finished_tasks.page.dart';
import 'package:mdi_todo/pages/task_list.page.dart';

final Localstore db = Localstore.instance;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MDI Todo'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.list),
              text: 'Task List',
            ),
            Tab(
              icon: Icon(Icons.check),
              text: 'Finished Tasks',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          TaskListPage(),
          FinishedTasksPage(),
        ],
      ),
    );
  }
}
