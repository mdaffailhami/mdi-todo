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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController _tabController;
  final _currentTabIndex = ValueNotifier(0);
  bool _isNotificationPermissionExplanationOpened = false;

  @override
  void initState() {
    super.initState();

    // Listen to app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load user's tasks
      context.read<TasksNotifier>().load();

      // Request notification permission
      await GetIt.I<NotificationService>().requestPermission();

      final permissionStatus =
          await GetIt.I<NotificationService>().permissionStatus;

      // If notification permission is not granted, then show explanation
      if (!permissionStatus.isGranted && mounted) {
        showNotificationPermissionExplanation(context);
      }
    });

    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      _currentTabIndex.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    // Remove app lifecycle listener
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    // Will run whenever the app resume after idle & permission explanation being opened
    if (state == AppLifecycleState.resumed &&
        _isNotificationPermissionExplanationOpened) {
      final permissionStatus =
          await GetIt.I<NotificationService>().permissionStatus;

      // If notification permission is granted, then close explanation dialog
      if (permissionStatus.isGranted && mounted) {
        Navigator.of(context).pop();
        _isNotificationPermissionExplanationOpened = false;
      }
    }
  }

  void showNotificationPermissionExplanation(BuildContext context) {
    _isNotificationPermissionExplanationOpened = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Permission Needed'),
          content: const Text(
            'We need notification permission to remind you about your tasks. '
            'Please enable it in app settings.',
          ),
          actions: [
            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(),
            //   child: const Text('Cancel'),                Naviga                Navigator.pop(context);tor.pop(context);
            // ),
            TextButton(
              onPressed: () async {
                await openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
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
