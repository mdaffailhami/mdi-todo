import 'package:get_it/get_it.dart';
import 'package:localstore/localstore.dart';
import 'package:mdi_todo/core/services/notification_service.dart';
import 'package:mdi_todo/data/data_sources/local/tasks_local_data_source.dart';
import 'package:mdi_todo/data/data_sources/local/theme_mode_local_data_source.dart';
import 'package:mdi_todo/data/repositories/tasks_repository.dart';
import 'package:mdi_todo/data/repositories/theme_mode_repository.dart';
import 'package:mdi_todo/presentation/notifiers/tasks_notifier.dart';
import 'package:mdi_todo/presentation/notifiers/theme_mode_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> injectDependencies() async {
  GetIt.I.registerSingletonAsync(
    () async => await SharedPreferences.getInstance(),
  );

  GetIt.I.registerSingleton(Localstore.instance);

  GetIt.I.registerSingleton(NotificationService());

  // Theme
  locator.registerLazySingleton(() => ThemeModeLocalDataSource());
  locator.registerLazySingleton(() => ThemeModeRepository());
  locator.registerLazySingleton(() => ThemeModeNotifier());

  // Tasks
  locator.registerLazySingleton(() => TasksLocalDataSource());
  locator.registerLazySingleton(() => TasksRepository());
  locator.registerLazySingleton(() => TasksNotifier());

  await GetIt.I.allReady();
}
