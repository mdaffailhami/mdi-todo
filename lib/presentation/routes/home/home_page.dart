import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mdi_todo/core/services/notification_service.dart';
import 'package:mdi_todo/presentation/notifiers/tasks_notifier.dart';
import 'package:mdi_todo/presentation/routes/home/app_bar.dart';
import 'package:mdi_todo/presentation/routes/home/completed_tasks/completed_task_list_tab.dart';
import 'package:mdi_todo/presentation/routes/home/task_form_dialog.dart';
import 'package:mdi_todo/presentation/routes/home/active_tasks/active_task_list_tab.dart';
import 'package:permission_handler/permission_handler.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load user's tasks
      context.read<TasksNotifier>().load();

      // Request notification permission
      await GetIt.I<NotificationService>().requestPermission();

      final permissionStatus =
          await GetIt.I<NotificationService>().permissionStatus;

      // If notification permission is not granted, then show explanation in 20% chance
      final random = Random().nextDouble();
      if (mounted && !permissionStatus.isGranted && random < 0.2) {
        showNotificationPermissionExplanation(context);
      }
    });

    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      _currentTabIndex.value = _tabController.index;
    });
  }

  void showNotificationPermissionExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission recommended'),
        content: const Text(
          'We need notification permission to remind you about your tasks. '
          'Please enable it in app settings.\n\n'
          "Don't worry, your tasks won't be saved in our database. Instead, your tasks will only be saved locally on your phone.\n"
          "So, we 100% know nothing about your tasks.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Don\'t notify'),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
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
