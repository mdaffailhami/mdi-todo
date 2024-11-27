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

  Future<void> scheduleNotification(Task task) async {
    await _notificationService.schedule(
      id: int.parse(task.id.substring(task.id.length - 5)),
      title: 'Reminder for your task',
      body: 'Don’t forget to complete "${task.title}"',
      scheduledTime: task.deadline,
    );
  }

  Future<void> cancelNotification(Task task) async {
    await _notificationService.cancel(int.parse(
      task.id.substring(task.id.length - 5),
    ));
  }
}
