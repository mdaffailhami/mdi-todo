part of 'add_task_bloc.dart';

abstract class _AddTaskEvent {}

class _AddTaskRequested extends _AddTaskEvent {
  final Task task;

  _AddTaskRequested(this.task);
}
