import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../main/builders/builders.dart';
import '../infra/helpers/helperts.dart';
import '../ui/components/components.dart';
import '../ui/helpers/helpers.dart';
import '../ui/mixins/mixins.dart';
import '../firebase_options.dart';
import '../main/factories/factories.dart';

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

class App extends StatelessWidget with HideNavigationBarManager {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    debugPrint("largura: ${MediaQuery.of(context).size.width}");
    debugPrint("altura: ${MediaQuery.of(context).size.height}");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => makeGetxCartPresenter(),
        ),
        ChangeNotifierProvider(
          create: (_) => makeGetxHomePresenter(),
        ),
        ChangeNotifierProvider(
          create: (_) => makeGetxPrintedProductsPresenter(),
        ),
        ListenableProvider(
          create: (_) => makeGetxCancelProductsPresenter(),
        ),
        ListenableProvider(
          create: (_) => makeGetxConfigurationsPresenter(),
        ),
        ListenableProvider(
          create: (_) => makeGetxEnterprisePresenter(),
        ),
        ListenableProvider(
          create: (_) => makeGetxExpansibleGroupFromProductPresenter(),
        ),
        ListenableProvider(
          create: (_) => makeGetxInsertProductsPresenter(),
        ),
        ListenableProvider(
          create: (_) => makeGetxMenuPresenter(),
        ),
        ListenableProvider(
          create: (_) => makeGetxPaymentPresenter(),
        ),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          UserInteraction.restartTimes();
        },
        onPanDown: (_) {
          UserInteraction.restartTimes();
        },
        child: GetMaterialApp(
          navigatorKey: NavigatorKey.navigatorKey,
          title: 'Celta restaurante',
          debugShowCheckedModeBanner: false,
          theme: makeAppTheme(context),
          navigatorObservers: [routeObserver],
          initialRoute: PageRoutes.splash,
          getPages: [
            GetPage(
              name: PageRoutes.cancelProducts,
              page: makeCancelProductsPage,
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: PageRoutes.covenant,
              page: makeCovenantPage,
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: PageRoutes.configurations,
              page: makeConfigurationsPage,
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: PageRoutes.enterpriseValidation,
              page: makeEnterpriseValidationPage,
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: PageRoutes.home,
              page: makeHomePage,
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: PageRoutes.insertProducts,
              page: makeInsertProductsPage,
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: PageRoutes.payment,
              page: makePaymentPage,
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: PageRoutes.printedProducts,
              page: () {
                return makePrintedProductsPage(
                  makeGetxHomePresenter().isFixedCommandNumber,
                );
              },
              transition: Transition.fadeIn,
            ),
            GetPage(
              name: PageRoutes.splash,
              page: makeSplashPage,
              transition: Transition.fade,
            ),
          ],
        ),
      ),
    );
  }
}
