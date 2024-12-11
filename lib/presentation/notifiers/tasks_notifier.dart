import 'package:flutter/widgets.dart';
import 'package:mdi_todo/core/dependencies.dart';
import 'package:mdi_todo/core/utils/generate_uid.dart';
import 'package:mdi_todo/core/utils/show_snack_bar.dart';
import 'package:mdi_todo/data/models/task.dart';
import 'package:mdi_todo/data/repositories/tasks_repository.dart';

class TasksNotifier extends ChangeNotifier {
  List<Task> _value = [];
  bool _isLoading = false;
  Exception? _error;

  List<Task> get value => _value;
  bool get isLoading => _isLoading;
  Exception? get error => _error;

  final TasksRepository _repository = locator<TasksRepository>();

  Future<void> load() async {
    try {
      _isLoading = true;
      notifyListeners();

      final tasks = await _repository.get();

      if (tasks.isNotEmpty) {
        _value = tasks;
        notifyListeners();
      }
    } catch (e) {
      _error = e as Exception;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Task? getById(String id) {
    try {
      return _value.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> add({required String title, required DateTime deadline}) async {
    try {
      final task = Task(
        id: generateUid(),
        title: title,
        deadline: deadline,
      );

      await _repository.add(task);

      await _repository.setNotification(task);

      _value.add(task);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> edit(
    Task task, {
    required String title,
    required DateTime deadline,
  }) async {
    try {
      final newTask = task.copyWith(
        title: title,
        deadline: deadline,
      );

      await _repository.edit(newTask);

      if (task.deadline != newTask.deadline) {
        await _repository.cancelNotification(task);
        await _repository.setNotification(newTask);
      }

      final index = _value.indexWhere((element) => element.id == task.id);

      _value[index] = newTask;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(Task task) async {
    try {
      await _repository.delete(task);
      await _repository.cancelNotification(task);

      final index = _value.indexWhere((element) => element.id == task.id);

      _value.removeAt(index);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _markTask(Task task, bool isCompleted) async {
    try {
      final newTask = task.copyWith(
        completedAt: () => isCompleted ? DateTime.now() : null,
      );

      await _repository.edit(newTask);

      final index = _value.indexWhere((element) => element.id == task.id);

      _value[index] = newTask;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markTaskAsCompleted(BuildContext context, Task task) async {
    try {
      await _markTask(task, true);
      await _repository.cancelNotification(task);

      if (context.mounted) {
        showSnackBar(
          context: context,
          label: 'Mark task as completed success',
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          label: 'Mark task as completed failed',
        );
      }
    }
  }

  Future<void> markTaskAsActive(BuildContext context, Task task) async {
    try {
      await _markTask(task, false);
      await _repository.setNotification(task);

      if (context.mounted) {
        showSnackBar(
          context: context,
          label: 'Mark task as active success',
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          label: 'Mark task as active failed',
        );
      }
    }
  }
}
