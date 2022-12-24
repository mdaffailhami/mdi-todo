part of 'mark_task_as_completed_bloc.dart';

abstract class MarkTaskAsCompletedState {}

class MarkTaskAsCompletedInitial extends MarkTaskAsCompletedState {}

class MarkTaskAsCompletedInProgress extends MarkTaskAsCompletedState {}

class MarkTaskAsCompletedFailure extends MarkTaskAsCompletedState {}

class MarkTaskAsCompletedSuccess extends MarkTaskAsCompletedState {
  final Task markedAsCompletedTask;

  MarkTaskAsCompletedSuccess(this.markedAsCompletedTask);
}
