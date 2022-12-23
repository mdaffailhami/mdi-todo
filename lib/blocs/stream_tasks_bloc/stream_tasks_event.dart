part of 'stream_tasks_bloc.dart';

abstract class _StreamTasksEvent {}

class _StreamTasksRequested extends _StreamTasksEvent {}

class _TaskAdded extends _StreamTasksEvent {
  final Task addedTask;

  _TaskAdded(this.addedTask);
}

class _TaskDeleted extends _StreamTasksEvent {
  final Task deletedTask;

  _TaskDeleted(this.deletedTask);
}

class _TaskEdited extends _StreamTasksEvent {
  final Task editedTask;

  _TaskEdited(this.editedTask);
}
