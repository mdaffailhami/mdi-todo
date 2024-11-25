import 'package:flutter/material.dart';
import 'package:mdi_todo/presentation/notifiers/tasks_notifier.dart';
import 'package:mdi_todo/presentation/routes/home/app_bar.dart';
import 'package:mdi_todo/presentation/routes/home/completed_tasks/completed_task_list_tab.dart';
import 'package:mdi_todo/presentation/routes/home/task_form_dialog.dart';
import 'package:mdi_todo/presentation/routes/home/active_tasks/active_task_list_tab.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _currentTabIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load user's tasks
      context.read<TasksNotifier>().load();
    });

    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      _currentTabIndex.value = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _currentTabIndex,
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: value == 0
              ? FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const MyTaskFormDialog.add(),
                    );
                  },
                  tooltip: 'Add task',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : null,
          body: child,
        );
      },
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [MyAppBar(tabController: _tabController)];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            MyActiveTaskListTab(),
            MyCompletedTaskListTab(),
          ],
        ),
      ),
    );
  }
}
