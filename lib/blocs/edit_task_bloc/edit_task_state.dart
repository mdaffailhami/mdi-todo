part of 'edit_task_bloc.dart';

abstract class EditTaskState {}

class EditTaskInitial extends EditTaskState {}

class EditTaskInProgress extends EditTaskState {}

class EditTaskFailure extends EditTaskState {}

class EditTaskSuccess extends EditTaskState {
  final Task editedTask;

  EditTaskSuccess(this.editedTask);
}
