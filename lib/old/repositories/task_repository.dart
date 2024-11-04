import 'package:localstore/localstore.dart';
import 'package:mdi_todo/old/models/task.dart';

class TaskRepository {
  final _tasksCollection = Localstore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    _tasksCollection.doc(task.id).set(task.toMap());
  }

  Future<void> deleteTaskById(String id) async {
    _tasksCollection.doc(id).delete();
  }

  Future<void> editTaskById(String id, {required Task task}) async {
    _tasksCollection.doc(id).set(task.toMap());
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
