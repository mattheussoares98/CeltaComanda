import 'package:flutter/foundation.dart';

import '../../data/models/conc_sale_request/conc_sale_request.dart';
import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
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
  final LoadDeliveryControl loadDeliveryControl;
  final ConcLoadSaleRequest concLoadSaleRequest;
  final WebLoadSettings webLoadSettings;

  GetxWebSaleRequestDetailsPresenter({
    required this.localEntepriseData,
    required this.loadEnterpriseData,
    required this.navigateTo,
    required this.loadDeliveryControl,
    required this.concLoadSaleRequest,
    required this.webLoadSettings,
  });

  @override
  Future<void> validateEnterprise(String enterpriseName) async {
    try {
      EnterpriseBuilder.entity = (EnterpriseBuilder.entity ??
              EnterpriseEntity.empty(enterpriseName))
          .copyWith(
              enterpriseName: enterpriseName.toLowerCase().removeWhiteSpaces());

      isLoading = true;
      mainError = null;

      final enterpriseData = await loadEnterpriseData.load();

      if (enterpriseData == null) {
        throw DomainError.enterpriseOrUrlNotFound;
      } else {
        isLoading = false;
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
  }

  final _saleRequestsStream = Rx<List<ConcSaleRequestModel>>([]);
  @override
  Stream<List<ConcSaleRequestModel>> get saleRequestsStream =>
      _saleRequestsStream.stream;

  @override
  Future<void> loadOpenSaleRequests({required bool isConsiderDelivered}) async {
    try {
      isLoading = true;
      mainError = null;

      _webLocalSettings ??= await webLoadSettings.load();
      final deliveryControls =
          await loadDeliveryControl.load(_webLocalSettings!);

      // _saleRequestsStream.subject.add(response);
      debugPrint(deliveryControls.toString());
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  WebLocalSettingsEntity? _webLocalSettings;
  @override
  WebLocalSettingsEntity? get webLocalSettings => _webLocalSettings;
}
