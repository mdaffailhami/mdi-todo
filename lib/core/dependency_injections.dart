import 'package:get_it/get_it.dart';
import 'package:localstore/localstore.dart';
import 'package:mdi_todo/data/data_sources/local/tasks_local_data_source.dart';
import 'package:mdi_todo/data/data_sources/local/theme_mode_local_data_source.dart';
import 'package:mdi_todo/data/repositories/tasks_repository.dart';
import 'package:mdi_todo/data/repositories/theme_mode_repository.dart';
import 'package:mdi_todo/presentation/providers/tasks_provider.dart';
import 'package:mdi_todo/presentation/providers/theme_mode_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingletonAsync(
    () async => await SharedPreferences.getInstance(),
  );

  getIt.registerSingleton(
    () => Localstore.instance,
  );

  getIt.registerLazySingleton(
    () => ThemeModeProvider(
      repository: ThemeModeRepository(
        localDataSource: ThemeModeLocalDataSource(
          sharedPreferences: getIt.get<SharedPreferences>(),
        ),
      ),
    ),
  );

  getIt.registerLazySingleton(
    () => TasksProvider(
      repository: TasksRepository(
        localDataSource: TasksLocalDataSource(
          localstore: Localstore.instance,
        ),
      ),
    ),
  );

  await getIt.allReady();
}
