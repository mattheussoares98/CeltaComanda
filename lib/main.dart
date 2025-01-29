import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../main/builders/builders.dart';
import 'infra/helpers/helperts.dart';
import '../ui/components/components.dart';
import '../ui/helpers/helpers.dart';
import '../ui/mixins/mixins.dart';
import '../firebase_options.dart';
import 'main/components/components.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky); //hide the buttons of navigation

  String? path;

  if (kIsWeb) {
    path = CacheKeys.hiveBoxName.name;
  } else {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    path = appDocumentDir.path;
  }
  Hive.init(path);
  await Hive.openBox(CacheKeys.hiveBoxName.name);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WakelockPlus.enable();

  runApp(const App());
}

class App extends StatelessWidget
    with HideNavigationBarManager, KeyboardManager {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    StringSize.updateStringSize(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    debugPrint("largura: ${MediaQuery.of(context).size.width}");
    debugPrint("altura: ${MediaQuery.of(context).size.height}");

    return MultiProvider(
      providers: Providers.providers,
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
          navigatorKey: NavigatorKey.navigatorKey,
          title: 'Celta restaurante',
          debugShowCheckedModeBanner: false,
          theme: makeAppTheme(context),
          navigatorObservers: [routeObserver],
          initialRoute: PageRoutes.splash,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          getPages: GetPages.getPages,
        ),
      ),
    );
  }
}
