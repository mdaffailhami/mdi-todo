// import 'package:either_dart/either.dart';
// import 'package:localstore/localstore.dart';
// import 'package:mdi_todo/core/request_failure.dart';

// class TasksLocalDataSource {
//   final Localstore localstore;

//   TasksLocalDataSource({required this.localstore});

//   Future<Either<RequestFailure, List<Map<String, dynamic>>>> getTasks() async {
//     try {
//       final docs = await localstore.collection('tasks').get();

//       if (docs == null) return const Right([]);

//       final List<Map<String, dynamic>> docsNew = [];

//       docs.forEach((key, value) => docsNew.add(value));

//       return Right(docsNew);
//     } catch (e) {
//       return Left(RequestFailure(e.toString()));
//     }
//   }

//   Future<Either<RequestFailure, void>> addTask(
//     Map<String, dynamic> task,
//   ) async {
//     try {
//       await localstore.collection('tasks').doc(task['id']).set(task);

//       return const Right(null);
//     } catch (e) {
//       return Left(RequestFailure(e.toString()));
//     }
//   }
// }
