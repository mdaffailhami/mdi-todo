import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/models/task.dart';
import 'package:mdi_todo/repositories/task_repository.dart';

part 'add_task_event.dart';
part 'add_task_state.dart';

class AddTaskBloc extends Bloc<_AddTaskEvent, AddTaskState> {
  void addTask(Task task) => add(_AddTaskRequested(task));

  AddTaskBloc({required TaskRepository taskRepository})
      : super(AddTaskInitial()) {
    on<_AddTaskRequested>((event, emit) async {
      emit(AddTaskInProgress());

      try {
        await taskRepository.addTask(event.task);

        emit(AddTaskSuccess(event.task));
      } catch (e) {
        emit(AddTaskFailure());
      }
    });
  }
}
