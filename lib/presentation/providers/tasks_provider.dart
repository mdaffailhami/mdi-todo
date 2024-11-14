import 'package:flutter/material.dart';
import 'package:mdi_todo/core/request_failure.dart';
import 'package:mdi_todo/core/request_state.dart';
import 'package:mdi_todo/data/models/task.dart';
import 'package:mdi_todo/data/repositories/tasks_repository.dart';
import 'package:mdi_todo/data/repositories/theme_mode_repository.dart';

class TasksProvider extends ChangeNotifier {
  final TasksRepository repository;

  TasksProvider({required this.repository});

  RequestState state = RequestState.loading;
  List<Task> value = [];
  RequestFailure? error;

  Future<void> load() async {
    (await repository.getTasks()).fold(
      (failure) {
        error = failure;
        state = RequestState.failed;
      },
      (value) {
        this.value = value;
        state = RequestState.loaded;
      },
    );

    notifyListeners();
  }

  Future<void> add({
    required String name,
    required DateTime deadline,
  }) async {
    final result = await repository.addTask(
      name: name,
      deadline: deadline,
    );

    result.fold(
      (failure) {
        error = failure;
        state = RequestState.failed;
      },
      (value) {
        state = RequestState.loaded;
        this.value.add(value);
      },
    );

    notifyListeners();
  }
}
