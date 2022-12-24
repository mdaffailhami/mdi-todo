import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/models/task.dart';
import 'package:mdi_todo/repositories/task_repository.dart';

part 'delete_task_event.dart';
part 'delete_task_state.dart';

class DeleteTaskBloc extends Bloc<_DeleteTaskEvent, DeleteTaskState> {
  void deleteTask(Task task) => add(_DeleteTaskRequested(task));

  DeleteTaskBloc({required TaskRepository taskRepository})
      : super(DeleteTaskInitial()) {
    on<_DeleteTaskRequested>((event, emit) async {
      emit(DeleteTaskInProgress());

      try {
        if (await taskRepository.getTaskById(event.task.id) != event.task) {
          throw Exception('Task not found.');
        }

        await taskRepository.deleteTaskById(event.task.id);

        emit(DeleteTaskSuccess(event.task));
      } catch (e) {
        log(e.toString());
        emit(DeleteTaskFailure());
      }
    });
  }
}
