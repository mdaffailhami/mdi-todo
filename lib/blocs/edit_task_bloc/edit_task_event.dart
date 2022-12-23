part of 'edit_task_bloc.dart';

abstract class _EditTaskEvent {}

class _EditTaskRequested extends _EditTaskEvent {
  final Task task;

  _EditTaskRequested(this.task);
}
