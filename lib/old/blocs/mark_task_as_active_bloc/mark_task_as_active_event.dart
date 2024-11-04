part of 'mark_task_as_active_bloc.dart';

abstract class _MarkTaskAsActiveEvent {}

class _MarkTaskAsActiveRequested extends _MarkTaskAsActiveEvent {
  final Task task;

  _MarkTaskAsActiveRequested(this.task);
}
