import 'package:flutter/material.dart';

import '../components/app_bar.dart';
import '../components/task_form_dialog.dart';
import '../tabs/active_task_list_tab.dart';
import '../tabs/completed_task_list_tab.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final currentTabIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);

    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentTabIndex,
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: value == 0
              ? FloatingActionButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const MyTaskFormDialog.add(),
                  ),
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
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [MyAppBar(tabController: tabController)];
        },
        body: TabBarView(
          controller: tabController,
          children: const [
            MyActiveTaskListTab(),
            MyCompletedTaskListTab(),
          ],
        ),
      ),
    );
  }
}
