import 'dart:convert';

import 'package:home_widget/home_widget.dart';
import 'package:mdi_todo/core/dependencies.dart';
import 'package:mdi_todo/core/services/notification_service.dart';
import 'package:mdi_todo/core/utils/format_date.dart';
import 'package:mdi_todo/data/data_sources/local/tasks_local_data_source.dart';
import 'package:mdi_todo/data/models/task.dart';

class TasksRepository {
  final _localDataSource = locator<TasksLocalDataSource>();
  final _notificationService = locator<NotificationService>();

  Future<List<Task>> get() async {
    try {
      return await _localDataSource.get();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> add(Task task) async {
    try {
      _localDataSource.add(task);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> edit(Task task) async {
    try {
      _localDataSource.edit(task);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(Task task) async {
    try {
      _localDataSource.delete(task);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setNotification(Task task) async {
    final now = DateTime.now();

    final d1 =
        DateTime(task.deadline.year, task.deadline.month, task.deadline.day);

    final d2 = DateTime(now.year, now.month, now.day);

    final differenceInDays = d1.difference(d2).inDays;

    // If the deadline is atleast the day after tomorrow
    if (differenceInDays > 1) {
      // Calculate scheduled date, the user will be notified 1 day before the deadline at 6 AM
      final scheduledDate =
          d1.add(const Duration(hours: 6)).subtract(const Duration(days: 1));

      // Schedule notification
      await _notificationService.scheduleNotification(
        id: int.parse(task.id.substring(task.id.length - 5)),
        title: 'Reminder for your task',
        body: 'Don’t forget to complete "${task.title}"',
        scheduledDate: scheduledDate,
      );
    } else {
      // Show instant notification
      await _notificationService.showInstantNotification(
        id: int.parse(task.id.substring(task.id.length - 5)),
        title: 'Reminder for your task',
        body: 'Don’t forget to complete "${task.title}"',
      );
    }
  }

  Future<void> cancelNotification(Task task) async {
    await _notificationService.cancelNotification(int.parse(
      task.id.substring(task.id.length - 5),
    ));
  }

  Future<void> saveAndUpdateActiveTasksWidget(List<Task> activeTasks) async {
    // Save data for app widget
    await HomeWidget.saveWidgetData(
      'active_tasks',
      jsonEncode(
        activeTasks
            .map((task) => {
                  'title': task.title,
                  'deadline': formatDate(task.deadline),
                })
            .toList(),
      ),
    );

    // Update (Notify to reload) app widget
    await HomeWidget.updateWidget(
      name: 'ActiveTasksWidgetReceiver',
      androidName: 'ActiveTasksWidgetReceiver',
    );
  }
}
