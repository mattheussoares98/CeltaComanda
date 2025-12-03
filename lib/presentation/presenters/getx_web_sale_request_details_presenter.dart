import 'package:provider/provider.dart';

import '../../main/builders/builders.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxWebSaleRequestDetailsPresenter extends GetxController
    with LoadingManager, UIErrorManager, ErrorHandling
    implements WebSaleRequestDetailsPresenter {
  @override
  Future<void> validateEnterprise() async {
    if (EnterpriseBuilder.entity != null) {
      //TODO probably is logged
    }

    final enterprisePresenter = Provider.of<EnterprisePresenter>(
        NavigatorKey.key.currentState!.context,
        listen: false);
    final homePresenter = Provider.of<HomePresenter>(
        NavigatorKey.key.currentState!.context,
        listen: false);

    enterprisePresenter.isUpdatedEnterpriseName =
        true; //needs to be sure that will search the enterprise

    await enterprisePresenter.validateEnterpriseByName(
      isFixedCommandNumber: false,
      commandNumber: '',
      homePresenter: homePresenter,
    );

    if (EnterpriseBuilder.entity != null) {
      //TODO worked
    }

    //TODO create tests
  }
}
