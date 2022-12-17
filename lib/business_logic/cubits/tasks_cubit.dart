import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/data/models/task.dart';
import 'package:mdi_todo/data/repositories/task_repository.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final _taskRepository = TaskRepository();

  TasksCubit() : super(TasksLoadInProgress()) {
    _loadTask();
  }

  Future<void> _loadTask() async {
    if (state is! TasksLoadInProgress) return;

    try {
      final tasks = await _taskRepository.getAllTasks();

      await Future.delayed(const Duration(seconds: 1));

      emit(TasksLoadSuccess(tasks));
    } on Exception catch (e) {
      log(e.toString());
      emit(TasksLoadFailure(e));
    }
  }

  Future<void> addTask(Task task) async {
    if (state is! TasksLoadSuccess) return;

    try {
      await _taskRepository.addTask(task);

      emit(TasksLoadSuccess(
        (state as TasksLoadSuccess).tasks..add(task),
      ));
    } on Exception catch (e) {
      log(e.toString());
      emit(TasksLoadFailure(e));
    }
  }

  Future<void> deleteTask(Task task) async {
    if (state is! TasksLoadSuccess) return;

    try {
      await _taskRepository.deleteTask(task);

      emit(TasksLoadSuccess(
        (state as TasksLoadSuccess).tasks..remove(task),
      ));
    } on Exception catch (e) {
      log(e.toString());
      emit(TasksLoadFailure(e));
    }
  }

  Future<void> editTask(Task task) async {
    if (state is! TasksLoadSuccess) return;

    try {
      await _taskRepository.editTask(task);

      final index = (state as TasksLoadSuccess)
          .tasks
          .indexWhere((element) => element.id == task.id);

      emit(TasksLoadSuccess(
        (state as TasksLoadSuccess).tasks
          ..replaceRange(index, index + 1, [task]),
      ));
    } on Exception catch (e) {
      log(e.toString());
      emit(TasksLoadFailure(e));
    }
  }

  Future<void> markTaskAsCompleted(Task task) async {
    if (state is! TasksLoadSuccess) return;

    try {
      await _taskRepository.markTaskAsCompleted(task);

      final edittedTask = await _taskRepository.getTaskById(task.id);

      final index = (state as TasksLoadSuccess)
          .tasks
          .indexWhere((element) => element.id == task.id);

      emit(
        TasksLoadSuccess((state as TasksLoadSuccess).tasks
          ..replaceRange(index, index + 1, [edittedTask!])),
      );
    } on Exception catch (e) {
      log(e.toString());
      emit(TasksLoadFailure(e));
    }
  }

  Future<void> markTaskAsActive(Task task) async {
    if (state is! TasksLoadSuccess) return;

    try {
      await _taskRepository.markTaskAsActive(task);

      final index = (state as TasksLoadSuccess)
          .tasks
          .indexWhere((element) => element.id == task.id);

      emit(
        TasksLoadSuccess((state as TasksLoadSuccess).tasks
          ..replaceRange(index, index + 1, [
            task.copyWith(
              completed: false,
              completionDateTime: () => null,
            )
          ])),
      );
    } on Exception catch (e) {
      log(e.toString());
      emit(TasksLoadFailure(e));
    }
  }
}
