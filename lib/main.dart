import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/router.dart';
import '../utils/theming.dart';

void main() {
  runApp(const App());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Theming.bgColor.withOpacity(0.002),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Theming.bgColor.withOpacity(0.002),
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routerConfig: router,
    );
  }
}
