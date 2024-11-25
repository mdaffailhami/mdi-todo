import 'package:mdi_todo/data/data_sources/local/tasks_local_data_source.dart';
import 'package:mdi_todo/data/models/task.dart';

class TasksRepository {
  final TasksLocalDataSource localDataSource = TasksLocalDataSource();

  Future<List<Task>> get() async {
    try {
      return await localDataSource.get();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> add(Task task) async {
    try {
      localDataSource.add(task);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> edit(Task task) async {
    try {
      localDataSource.edit(task);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(Task task) async {
    try {
      localDataSource.delete(task);
    } catch (e) {
      rethrow;
    }
  }
}
