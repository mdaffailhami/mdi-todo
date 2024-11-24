import 'package:get_it/get_it.dart';
import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> injectDependencies() async {
  GetIt.I.registerSingletonAsync(
    () async => await SharedPreferences.getInstance(),
  );

  GetIt.I.registerSingleton(
    () => Localstore.instance,
  );

  await GetIt.I.allReady();
}
