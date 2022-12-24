part of 'add_task_bloc.dart';

abstract class _AddTaskEvent {}

class _AddTaskRequested extends _AddTaskEvent {
  final String name;
  final DateTime deadline;

  _AddTaskRequested({required this.name, required this.deadline});
}
