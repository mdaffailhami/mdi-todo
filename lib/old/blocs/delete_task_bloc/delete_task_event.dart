part of 'delete_task_bloc.dart';

abstract class _DeleteTaskEvent {}

class _DeleteTaskRequested extends _DeleteTaskEvent {
  final Task task;

  _DeleteTaskRequested(this.task);
}
