part of 'tasks_cubit.dart';

abstract class TasksState {}

class TasksLoadInProgress extends TasksState {}

class TasksLoadFailure extends TasksState {
  final Exception exception;

  TasksLoadFailure(this.exception);
}

class TasksLoadSuccess extends TasksState {
  final List<Task> tasks;

  List<Task> get activeTasks =>
      tasks.where((task) => task.completed == false).toList();

  List<Task> get completedTasks =>
      tasks.where((task) => task.completed == true).toList();

  List<Task> get sortedActiveTasks => List.from(activeTasks)
    ..sort(
      (a, b) => a.deadline.millisecondsSinceEpoch.compareTo(
        b.deadline.millisecondsSinceEpoch,
      ),
    );

  List<Task> get sortedCompletedTasks => List.from(completedTasks)
    ..sort(
      (a, b) => b.completionDateTime!.millisecondsSinceEpoch.compareTo(
        a.completionDateTime!.millisecondsSinceEpoch,
      ),
    );

  TasksLoadSuccess(this.tasks);
}
