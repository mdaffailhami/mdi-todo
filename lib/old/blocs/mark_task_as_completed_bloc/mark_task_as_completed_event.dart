part of 'mark_task_as_completed_bloc.dart';

abstract class _MarkTaskAsCompletedEvent {}

class _MarkTaskAsCompletedRequested extends _MarkTaskAsCompletedEvent {
  final Task task;

  _MarkTaskAsCompletedRequested(this.task);
}
