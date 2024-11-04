import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/old/models/task.dart';
import 'package:mdi_todo/old/repositories/task_repository.dart';

part 'mark_task_as_active_event.dart';
part 'mark_task_as_active_state.dart';

class MarkTaskAsActiveBloc
    extends Bloc<_MarkTaskAsActiveEvent, MarkTaskAsActiveState> {
  void markTaskAsActive(Task task) => add(_MarkTaskAsActiveRequested(task));

  MarkTaskAsActiveBloc({required TaskRepository taskRepository})
      : super(MarkTaskAsActiveInitial()) {
    on<_MarkTaskAsActiveRequested>((event, emit) async {
      emit(MarkTaskAsActiveInProgress());

      try {
        if (await taskRepository.getTaskById(event.task.id) != event.task) {
          throw Exception('Task not found.');
        }

        final newTask = Task.from(event.task);
        newTask.completed = false;
        newTask.completionDateTime = DateTime.now();

        await taskRepository.editTaskById(event.task.id, task: newTask);

        emit(MarkTaskAsActiveSuccess(newTask));
      } catch (e) {
        log(e.toString());
        emit(MarkTaskAsActiveFailure());
      }
    });
  }
}
