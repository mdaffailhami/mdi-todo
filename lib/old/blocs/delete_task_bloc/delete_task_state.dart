part of 'delete_task_bloc.dart';

abstract class DeleteTaskState {}

class DeleteTaskInitial extends DeleteTaskState {}

class DeleteTaskInProgress extends DeleteTaskState {}

class DeleteTaskFailure extends DeleteTaskState {}

class DeleteTaskSuccess extends DeleteTaskState {
  final Task deletedTask;

  DeleteTaskSuccess(this.deletedTask);
}
