import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../main/builders/builders.dart';
import '../ui/components/components.dart';
import '../ui/helpers/helpers.dart';
import '../ui/mixins/mixins.dart';
import 'main/components/components.dart';
import 'main/init/init.dart';

void main() async {
  await initApp();

  runApp(const App());
}

class App extends StatelessWidget
    with HideNavigationBarManager, KeyboardManager {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    StringSize.updateStringSize(context);
    ScreenSize.updateHasMinWidth(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    debugPrint("largura: ${MediaQuery.of(context).size.width}");
    debugPrint("altura: ${MediaQuery.of(context).size.height}");

    return MultiProvider(
      providers: Providers.providers,
      child: OrientationController(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            UserInteraction.restartTimes();
            FocusScope.of(context).unfocus();
            hideKeyboard(context);
          },
          onPanDown: (_) {
            UserInteraction.restartTimes();
            FocusScope.of(context).unfocus();
            hideKeyboard(context);
          },
          child: GetMaterialApp(
            navigatorKey: NavigatorKey.key,
            title: 'Celta restaurante',
            debugShowCheckedModeBanner: false,
            theme: makeAppTheme(context),
            navigatorObservers: [routeObserver],
            initialRoute: PageRoutes.splash,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            getPages: GetPages.getPages,
          ),
        ),
      ),
    );
  }
}
