import 'package:either_dart/either.dart';
import 'package:mdi_todo/core/request_failure.dart';
import 'package:mdi_todo/core/utils/generate_uid.dart';
import 'package:mdi_todo/data/data_sources/local/tasks_local_data_source.dart';
import 'package:mdi_todo/data/models/task.dart';

class TasksRepository {
  final TasksLocalDataSource localDataSource;

  TasksRepository({required this.localDataSource});

  Future<Either<RequestFailure, List<Task>>> getTasks() async {
    final docs = await localDataSource.getTasks();

    return docs.fold(
      (failure) {
        return Left(failure);
      },
      (value) {
        return Right(value.map((e) => Task.fromMap(e)).toList());
      },
    );
  }

  Future<Either<RequestFailure, Task>> addTask({
    required String name,
    required DateTime deadline,
  }) async {
    final task = Task(
      id: generateUid(),
      name: name,
      deadline: deadline,
      completed: false,
    );

    return localDataSource.addTask(task.toMap()).fold(
      (left) {
        return Left(left);
      },
      (right) {
        return Right(task);
      },
    );
  }
}
