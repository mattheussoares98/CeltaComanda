import 'package:provider/provider.dart';

import '../builders.dart';
import '../../../ui/pages/pages.dart';

class UserInteraction {
  UserInteraction._();

  static CartPresenter cartPresenter = Provider.of(
    NavigatorKey.navigatorKey.currentState!.context,
    listen: false,
  );
  static MenuPresenter menuPresenter = Provider.of(
    NavigatorKey.navigatorKey.currentState!.context,
    listen: false,
  );

  static void restartTimes() {
    CartNotEmptyInteraction.restartTime();
    ShowDetachLargeItemsInteraction.restartTime();
  }
}
