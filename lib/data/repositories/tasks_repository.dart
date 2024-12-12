import 'package:get_it/get_it.dart';
import 'package:mdi_todo/core/services/notification_service.dart';
import 'package:mdi_todo/data/data_sources/local/tasks_local_data_source.dart';
import 'package:mdi_todo/data/models/task.dart';

class TasksRepository {
  final _localDataSource = TasksLocalDataSource();
  final _notificationService = GetIt.I.get<NotificationService>();

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

  /// Set notifications for a given [task].
  ///
  /// If the deadline is at least the day after tomorrow, the user will be
  /// notified at the deadline at 6 AM and 1 day before the deadline at 6 AM.
  ///
  /// If the deadline is tomorrow, the user will be notified at the deadline at
  /// 6 AM and also an instant notification will be shown.
  ///
  /// If the deadline is today, an instant notification will be shown.
  Future<void> setNotification(Task task) async {
    final now = DateTime.now();

    final d1 =
        DateTime(task.deadline.year, task.deadline.month, task.deadline.day);

    final d2 = DateTime(now.year, now.month, now.day);

    final differenceInDays = d1.difference(d2).inDays;

    // If the deadline is atleast the day after tomorrow
    if (differenceInDays > 1) {
      // Calculate scheduled date, the user will be notified at the deadline at 6 AM and 1 day before the deadline at 6 AM
      final scheduledDates = [
        d1.add(const Duration(hours: 6)).subtract(const Duration(days: 1)),
        d1.add(const Duration(hours: 6)),
      ];

      // Schedule 2 notifications
      for (var i = 0; i < scheduledDates.length; i++) {
        _notificationService.scheduleNotification(
          id: int.parse('${i + 1}${task.id.substring(task.id.length - 5)}'),
          title: 'Reminder for your task',
          body: 'Don’t forget to complete "${task.title}"',
          scheduledDate: scheduledDates[i],
        );
      }
    } else if (differenceInDays == 1) {
      // Scheduled date, the user will be notified at the deadline at 6 AM
      final scheduledDate = d1.add(const Duration(hours: 6));

      // Make 2 notifications

      // Show instant notification
      _notificationService.showInstantNotification(
        id: int.parse('1${task.id.substring(task.id.length - 5)}'),
        title: 'Reminder for your task',
        body: 'Don’t forget to complete "${task.title}"',
      );

      // Schedule notification
      _notificationService.scheduleNotification(
        id: int.parse('2${task.id.substring(task.id.length - 5)}'),
        title: 'Reminder for your task',
        body: 'Don’t forget to complete "${task.title}"',
        scheduledDate: scheduledDate,
      );
    } else {
      // Show instant notification
      _notificationService.showInstantNotification(
        id: int.parse('1${task.id.substring(task.id.length - 5)}'),
        title: 'Reminder for your task',
        body: 'Don’t forget to complete "${task.title}"',
      );
    }
  }

  /// Cancel scheduled notifications for a given [task].
  ///
  /// This method tries to cancel both the first (1 day before the deadline) and the
  /// second (at the deadline) notification.
  Future<void> cancelNotification(Task task) async {
    await _notificationService.cancelNotification(int.parse(
      '1${task.id.substring(task.id.length - 5)}',
    ));

    await _notificationService.cancelNotification(int.parse(
      '2${task.id.substring(task.id.length - 5)}',
    ));
  }
}
