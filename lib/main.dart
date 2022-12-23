import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/blocs/add_task_bloc/add_task_bloc.dart';
import 'package:mdi_todo/blocs/change_theme_mode_bloc/change_theme_mode_bloc.dart';
import 'package:mdi_todo/blocs/delete_task_bloc/delete_task_bloc.dart';
import 'package:mdi_todo/blocs/edit_task_bloc/edit_task_bloc.dart';
import 'package:mdi_todo/blocs/stream_theme_mode_bloc/stream_theme_mode_bloc.dart';
import 'package:mdi_todo/blocs/stream_tasks_bloc/stream_tasks_bloc.dart';
import 'package:mdi_todo/repositories/task_repository.dart';
import 'package:mdi_todo/repositories/theme_mode_repository.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Setting SysemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  // Setting SystmeUIMode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  final themeModeRepository = ThemeModeRepository();
  final taskRepository = TaskRepository();

  final changeThemeModeBloc = ChangeThemeModeBloc(
    themeModeRepository: themeModeRepository,
  );
  final streamThemeModeBloc = StreamThemeModeBloc(
    changeThemeModeBloc: changeThemeModeBloc,
    themeModeRepository: themeModeRepository,
  );
  final addTaskBloc = AddTaskBloc(taskRepository: taskRepository);
  final deleteTaskBloc = DeleteTaskBloc(taskRepository: taskRepository);
  final editTaskBloc = EditTaskBloc(taskRepository: taskRepository);
  final streamTasksBloc = StreamTasksBloc(
    addTaskBloc: addTaskBloc,
    deleteTaskBloc: deleteTaskBloc,
    editTaskBloc: editTaskBloc,
    taskRepository: taskRepository,
  );

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => changeThemeModeBloc),
      BlocProvider(create: (context) => streamThemeModeBloc),
      BlocProvider(create: (context) => addTaskBloc),
      BlocProvider(create: (context) => deleteTaskBloc),
      BlocProvider(create: (context) => editTaskBloc),
      BlocProvider(create: (context) => streamTasksBloc),
    ],
    child: const MyApp(),
  ));
}
