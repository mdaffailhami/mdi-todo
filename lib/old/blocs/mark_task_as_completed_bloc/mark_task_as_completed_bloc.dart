import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/old/models/task.dart';
import 'package:mdi_todo/old/repositories/task_repository.dart';

part 'mark_task_as_completed_event.dart';
part 'mark_task_as_completed_state.dart';

class MarkTaskAsCompletedBloc
    extends Bloc<_MarkTaskAsCompletedEvent, MarkTaskAsCompletedState> {
  void markTaskAsCompleted(Task task) {
    add(_MarkTaskAsCompletedRequested(task));
  }

  MarkTaskAsCompletedBloc({required TaskRepository taskRepository})
      : super(MarkTaskAsCompletedInitial()) {
    on<_MarkTaskAsCompletedRequested>((event, emit) async {
      emit(MarkTaskAsCompletedInProgress());

      try {
        if (await taskRepository.getTaskById(event.task.id) != event.task) {
          throw Exception('Task not found.');
        }

        final newTask = Task.from(event.task);
        newTask.completed = true;
        newTask.completionDateTime = DateTime.now();

        await taskRepository.editTaskById(event.task.id, task: newTask);

        emit(MarkTaskAsCompletedSuccess(newTask));
      } catch (e) {
        log(e.toString());
        emit(MarkTaskAsCompletedFailure());
      }
    });
  }
}
