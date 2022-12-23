part of 'add_task_bloc.dart';

abstract class AddTaskState {}

class AddTaskInitial extends AddTaskState {}

class AddTaskInProgress extends AddTaskState {}

class AddTaskFailure extends AddTaskState {}

class AddTaskSuccess extends AddTaskState {
  final Task addedTask;

  AddTaskSuccess(this.addedTask);
}
