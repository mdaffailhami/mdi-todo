import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/models/task.dart';
import 'package:mdi_todo/repositories/task_repository.dart';

part 'mark_task_as_completed_event.dart';
part 'mark_task_as_completed_state.dart';

class MarkTaskAsCompletedBloc
    extends Bloc<_MarkTaskAsCompletedEvent, MarkTaskAsCompletedState> {
  void markTaskAsCompleted(Task task) =>
      add(_MarkTaskAsCompletedRequested(task));

  MarkTaskAsCompletedBloc({required TaskRepository taskRepository})
      : super(MarkTaskAsCompletedInitial()) {
    on<_MarkTaskAsCompletedRequested>((event, emit) async {
      emit(MarkTaskAsCompletedInProgress());

      try {
        final newTask = Task.from(event.task);
        newTask.completed = true;
        newTask.completionDateTime = DateTime.now();

        await taskRepository.editTask(newTask);

        emit(MarkTaskAsCompletedSuccess(newTask));
      } catch (e) {
        emit(MarkTaskAsCompletedFailure());
      }
    });
  }
}
