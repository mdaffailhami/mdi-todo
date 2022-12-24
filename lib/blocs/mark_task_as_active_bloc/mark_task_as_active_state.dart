part of 'mark_task_as_active_bloc.dart';

abstract class MarkTaskAsActiveState {}

class MarkTaskAsActiveInitial extends MarkTaskAsActiveState {}

class MarkTaskAsActiveInProgress extends MarkTaskAsActiveState {}

class MarkTaskAsActiveFailure extends MarkTaskAsActiveState {}

class MarkTaskAsActiveSuccess extends MarkTaskAsActiveState {
  final Task markedAsActiveTask;

  MarkTaskAsActiveSuccess(this.markedAsActiveTask);
}
