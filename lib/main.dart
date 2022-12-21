import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'presentation/app.dart';

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

  runApp(const MyApp());
}
