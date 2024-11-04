part of 'stream_tasks_bloc.dart';

abstract class StreamTasksState {}

class StreamTasksInitial extends StreamTasksState {}

class StreamTasksInProgress extends StreamTasksState {}

class StreamTasksFailure extends StreamTasksState {}

class StreamTasksSuccess extends StreamTasksState {
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

  StreamTasksSuccess(this.tasks);
}
