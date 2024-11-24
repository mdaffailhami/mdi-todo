import 'package:flutter/material.dart';
import 'package:mdi_todo/presentation/components/app_bar.dart';
import 'package:mdi_todo/presentation/components/task_form_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final currentTabIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    // BlocProvider.of<StreamTasksBloc>(context).streamTasks();

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
                  onPressed: () {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => const MyTaskFormDialog.add(),
                    // );
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
          return [MyAppBar(tabController: tabController)];
        },
        body: TabBarView(
          controller: tabController,
          children: const [
            // MyActiveTaskListTab(),
            // MyCompletedTaskListTab(),
            SizedBox(),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
