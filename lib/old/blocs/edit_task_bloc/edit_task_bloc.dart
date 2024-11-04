import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/old/models/task.dart';
import 'package:mdi_todo/old/repositories/task_repository.dart';

part 'edit_task_event.dart';
part 'edit_task_state.dart';

class EditTaskBloc extends Bloc<_EditTaskEvent, EditTaskState> {
  void editTask(Task task, {String? name, DateTime? deadline}) {
    add(_EditTaskRequested(task, name: name, deadline: deadline));
  }

  EditTaskBloc({required TaskRepository taskRepository})
      : super(EditTaskInitial()) {
    on<_EditTaskRequested>((event, emit) async {
      emit(EditTaskInProgress());

      try {
        if (await taskRepository.getTaskById(event.task.id) != event.task) {
          throw Exception('Task not found.');
        }

        final newTask = Task.from(event.task);
        newTask.name = event.name;
        newTask.deadline = event.deadline;

        await taskRepository.editTaskById(event.task.id, task: newTask);

        emit(EditTaskSuccess(newTask));
      } catch (e) {
        log(e.toString());
        emit(EditTaskFailure());
      }
    });
  }
}
