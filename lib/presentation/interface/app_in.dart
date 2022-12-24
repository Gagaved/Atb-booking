import 'package:flutter/material.dart';

import '../constants/styles.dart';
import '../router/app_router.dart';

class Application extends StatelessWidget {
  final String typeUser;
  Application({Key? key, required this.typeUser}) : super(key: key);
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Заголовок и тема
      title: 'ATB Flutter Demo',
      theme: appThemeData,
      darkTheme: appDarkThemeData,
      themeMode: ThemeMode.system,
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
