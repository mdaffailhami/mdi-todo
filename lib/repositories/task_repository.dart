import 'package:localstore/localstore.dart';

import '../models/task.dart';

class TaskRepository {
  final _tasksCollection = Localstore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    _tasksCollection.doc(task.id).set(task.toMap());
  }

  Future<void> deleteTask(Task task) async {
    if (await getTaskById(task.id) == null) throw Exception('Task not found!');

    _tasksCollection.doc(task.id).delete();
  }

  Future<void> editTask(Task task) async {
    if (await getTaskById(task.id) == null) throw Exception('Task not found!');

    _tasksCollection.doc(task.id).set(task.toMap());
  }

  Future<Task?> getTaskById(String id) async {
    final doc = await _tasksCollection.doc(id).get();

    if (doc == null) return null;

    return Task.fromMap(doc);
  }

  Future<List<Task>> getAllTasks() async {
    final docs = await _tasksCollection.get();
    await Future.delayed(const Duration(seconds: 1));

    if (docs == null) return [];

    List<Task> tasks = [];

    docs.forEach((key, value) => tasks.add(Task.fromMap(value)));

    return tasks;
  }
}
