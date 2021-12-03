import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:mdi_todo/tabs/finished_tasks.tab.dart';
import 'package:mdi_todo/tabs/task_list.tab.dart';

final Localstore db = Localstore.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
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
          TaskListTab(),
          FinishedTasksTab(),
        ],
      ),
    );
  }
}
