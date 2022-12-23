import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/models/task.dart';
import 'package:mdi_todo/repositories/task_repository.dart';

part 'edit_task_event.dart';
part 'edit_task_state.dart';

class EditTaskBloc extends Bloc<_EditTaskEvent, EditTaskState> {
  void editTask(Task task) => add(_EditTaskRequested(task));

  EditTaskBloc({required TaskRepository taskRepository})
      : super(EditTaskInitial()) {
    on<_EditTaskRequested>((event, emit) async {
      emit(EditTaskInProgress());

      try {
        await taskRepository.editTask(event.task);

        emit(EditTaskSuccess(event.task));
      } catch (e) {
        emit(EditTaskFailure());
      }
    });
  }
}
