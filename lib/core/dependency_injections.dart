import 'package:get_it/get_it.dart';
import 'package:mdi_todo/data/data_sources/local/theme_mode_local_data_source.dart';
import 'package:mdi_todo/data/repositories/theme_mode_repository.dart';
import 'package:mdi_todo/presentation/providers/theme_mode_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingletonAsync(
    () async => await SharedPreferences.getInstance(),
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

  await getIt.allReady();
}
