part of 'edit_task_bloc.dart';

abstract class _EditTaskEvent {}

class _EditTaskRequested extends _EditTaskEvent {
  final Task task;
  final String name;
  final DateTime deadline;

  _EditTaskRequested(
    this.task, {
    String? name,
    DateTime? deadline,
  })  : name = name ?? task.name,
        deadline = deadline ?? task.deadline;
}
