import '../../data/usecases/usecases.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxWebSaleRequestDetailsPresenter extends GetxController
    with LoadingManager, UIErrorManager, ErrorHandling
    implements WebSaleRequestDetailsPresenter {
  final LocalEnterpriseData localEntepriseData;
  final LoadEnterpriseData loadEnterpriseData;
  final NavigateTo navigateTo;

  GetxWebSaleRequestDetailsPresenter({
    required this.localEntepriseData,
    required this.loadEnterpriseData,
    required this.navigateTo,
  });

  @override
  Future<void> validateEnterprise(String enterpriseName) async {
    try {
      EnterpriseBuilder.entity = EnterpriseBuilder.entity?.copyWith(
          enterpriseName: enterpriseName.toLowerCase().removeWhiteSpaces());

      isLoading = true;
      mainError = null;

      final enterpriseData = await loadEnterpriseData.load();

      if (enterpriseData == null) {
        throw DomainError.enterpriseOrUrlNotFound;
      } else {
        EnterpriseBuilder.entity = enterpriseData;
        await localEntepriseData.add(enterpriseData);
        navigateTo.navigate(
            pageRoute: PageRoutes.webSaleRequestDetails, clear: true);
      }
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
    //TODO create tests
  }
}
