import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../firebase_options.dart';

import '../infra/helpers/helperts.dart';
import '../presentation/presenters/presenters.dart';
import '../ui/components/components.dart';
import '../ui/helpers/helpers.dart';
import './factories/factories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox(CacheKeys.hiveBoxName.name);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GetxCartPresenter(),
        ),
        ChangeNotifierProvider(
          create: (_) => GetxExpansibleGroupsPresenter(
            loadCommandsAvailable: makeRemoteLoadCommandsAvailable(),
            loadExpansibleGroups: makeRemoteLoadExpansibleGroups(),
            localEnterpriseData: makeLocalEnterpriseData(),
            navigateTo: makeNavigateTo(),
          ),
        ),
      ],
      child: GetMaterialApp(
        title: 'Celta restaurante',
        debugShowCheckedModeBanner: false,
        theme: makeAppTheme(),
        navigatorObservers: [routeObserver],
        initialRoute: PageRoutes.splash,
        getPages: [
          GetPage(
            name: PageRoutes.splash,
            page: makeSplashPage,
            transition: Transition.fade,
          ),
          GetPage(
            name: PageRoutes.enterpriseValidation,
            page: makeEnterpriseValidationPage,
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: PageRoutes.expansibleGroups,
            page: makeExpansibleGroupsPage,
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: PageRoutes.products,
            page: makeProductsPage,
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: PageRoutes.cart,
            page: makeCartPage,
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: PageRoutes.productDetails,
            page: makeProductDetailsPage,
            transition: Transition.fadeIn,
          ),
        ],
      ),
    );
  }
}
