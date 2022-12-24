import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/models/task.dart';
import 'package:mdi_todo/repositories/task_repository.dart';
import 'package:mdi_todo/utils/generate_uid.dart';

part 'add_task_event.dart';
part 'add_task_state.dart';

class AddTaskBloc extends Bloc<_AddTaskEvent, AddTaskState> {
  void addTask({required String name, required DateTime deadline}) {
    add(_AddTaskRequested(name: name, deadline: deadline));
  }

  AddTaskBloc({required TaskRepository taskRepository})
      : super(AddTaskInitial()) {
    on<_AddTaskRequested>((event, emit) async {
      emit(AddTaskInProgress());

      try {
        final task = Task(
          id: generateUid(),
          name: event.name,
          deadline: event.deadline,
          completed: false,
        );

        await taskRepository.addTask(task);

        emit(AddTaskSuccess(task));
      } catch (e) {
        emit(AddTaskFailure());
      }
    });
  }
}
