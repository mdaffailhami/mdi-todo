import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/blocs/stream_tasks_bloc/stream_tasks_bloc.dart';
import 'package:mdi_todo/components/app_bar.dart';
import 'package:mdi_todo/components/task_form_dialog.dart';
import 'package:mdi_todo/tabs/active_task_list_tab.dart';
import 'package:mdi_todo/tabs/completed_task_list_tab.dart';

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

    BlocProvider.of<StreamTasksBloc>(context).streamTasks();

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
        floatHeaderSlivers: true,
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
