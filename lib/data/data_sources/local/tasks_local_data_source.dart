import 'package:get_it/get_it.dart';
import 'package:localstore/localstore.dart';
import 'package:mdi_todo/data/models/task.dart';

class TasksLocalDataSource {
  final CollectionRef _collection = GetIt.I<Localstore>().collection('tasks');

  Future<List<Task>> get() async {
    try {
      final docs = await _collection.get();

      if (docs == null) return [];

      final List<Task> tasks = [];

      docs.forEach((key, value) => tasks.add(Task.fromMap(value)));

      return tasks;
    } catch (e) {
      throw Exception('Get tasks failed: ${e.toString()}');
    }
  }

  Future<void> add(Task task) async {
    try {
      await _collection.doc(task.id).set(task.toMap());
    } catch (e) {
      throw Exception('Add task failed: ${e.toString()}');
    }
  }

  Future<void> edit(Task task) async {
    try {
      await _collection.doc(task.id).set(task.toMap());
    } catch (e) {
      throw Exception('Edit task failed: ${e.toString()}');
    }
  }

  Future<void> delete(Task task) async {
    try {
      await _collection.doc(task.id).delete();
    } catch (e) {
      throw Exception('Delete task failed: ${e.toString()}');
    }
  }
}
