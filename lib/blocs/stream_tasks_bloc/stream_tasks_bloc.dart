import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/blocs/add_task_bloc/add_task_bloc.dart';
import 'package:mdi_todo/blocs/delete_task_bloc/delete_task_bloc.dart';
import 'package:mdi_todo/blocs/edit_task_bloc/edit_task_bloc.dart';
import 'package:mdi_todo/blocs/mark_task_as_active_bloc/mark_task_as_active_bloc.dart';
import 'package:mdi_todo/blocs/mark_task_as_completed_bloc/mark_task_as_completed_bloc.dart';
import 'package:mdi_todo/models/task.dart';
import 'package:mdi_todo/repositories/task_repository.dart';

part 'stream_tasks_event.dart';
part 'stream_tasks_state.dart';

class StreamTasksBloc extends Bloc<_StreamTasksEvent, StreamTasksState> {
  StreamSubscription<AddTaskState>? _addTaskSubscription;
  StreamSubscription<DeleteTaskState>? _deleteTaskSubscription;
  StreamSubscription<EditTaskState>? _editTaskSubscription;
  StreamSubscription<MarkTaskAsCompletedState>?
      _markTaskAsCompletedSubscription;
  StreamSubscription<MarkTaskAsActiveState>? _markTaskAsActiveSubscription;

  void streamTasks() => add(_StreamTasksRequested());

  @override
  Future<void> close() {
    _addTaskSubscription?.cancel();
    _deleteTaskSubscription?.cancel();
    _editTaskSubscription?.cancel();
    _markTaskAsCompletedSubscription?.cancel();
    _markTaskAsActiveSubscription?.cancel();

    return super.close();
  }

  StreamTasksBloc({
    required AddTaskBloc addTaskBloc,
    required DeleteTaskBloc deleteTaskBloc,
    required EditTaskBloc editTaskBloc,
    required MarkTaskAsCompletedBloc markTaskAsCompletedBloc,
    required MarkTaskAsActiveBloc markTaskAsActiveBloc,
    required TaskRepository taskRepository,
  }) : super(StreamTasksInitial()) {
    on<_StreamTasksRequested>((event, emit) async {
      emit(StreamTasksInProgress());

      try {
        final tasks = await taskRepository.getAllTasks();

        _addTaskSubscription = addTaskBloc.stream.listen((state) {
          if (state is AddTaskSuccess) {
            add(_TaskAdded(state.addedTask));
          }
        });

        _deleteTaskSubscription = deleteTaskBloc.stream.listen((state) {
          if (state is DeleteTaskSuccess) {
            add(_TaskDeleted(state.deletedTask));
          }
        });

        _editTaskSubscription = editTaskBloc.stream.listen((state) {
          if (state is EditTaskSuccess) {
            add(_TaskEdited(state.editedTask));
          }
        });

        _markTaskAsCompletedSubscription =
            markTaskAsCompletedBloc.stream.listen((state) {
          if (state is MarkTaskAsCompletedSuccess) {
            add(_TaskEdited(state.markedAsCompletedTask));
          }
        });

        _markTaskAsActiveSubscription =
            markTaskAsActiveBloc.stream.listen((state) {
          if (state is MarkTaskAsActiveSuccess) {
            add(_TaskEdited(state.markedAsActiveTask));
          }
        });

        emit(StreamTasksSuccess(tasks));
      } catch (e) {
        emit(StreamTasksFailure());
      }
    });

    on<_TaskAdded>((event, emit) {
      if (state is StreamTasksSuccess) {
        emit(StreamTasksSuccess(
          (state as StreamTasksSuccess).tasks..add(event.addedTask),
        ));
      }
    });

    on<_TaskDeleted>((event, emit) {
      if (state is StreamTasksSuccess) {
        emit(StreamTasksSuccess(
          (state as StreamTasksSuccess).tasks..remove(event.deletedTask),
        ));
      }
    });

    on<_TaskEdited>((event, emit) {
      if (state is StreamTasksSuccess) {
        final index = (state as StreamTasksSuccess)
            .tasks
            .indexWhere((element) => element.id == event.editedTask.id);

        emit(StreamTasksSuccess(
          (state as StreamTasksSuccess).tasks
            ..replaceRange(index, index + 1, [event.editedTask]),
        ));
      }
    });
  }
}
