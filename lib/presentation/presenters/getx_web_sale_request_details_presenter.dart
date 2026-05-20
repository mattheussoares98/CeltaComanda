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
  final LoadPrintedProducts loadPrintedProducts;
  final WebLoadSettings webLoadSettings;
  final ConcDeliveryControl concDeliveryControl;
  final ConcLoadSaleMovement concLoadSaleMovement;

  GetxWebSaleRequestDetailsPresenter({
    required this.localEntepriseData,
    required this.loadEnterpriseData,
    required this.navigateTo,
    required this.loadPrintedProducts,
    required this.webLoadSettings,
    required this.concDeliveryControl,
    required this.concLoadSaleMovement,
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

  final _saleRequestsStream = Rx<Map<String, PrintedEntity>>({});
  @override
  Stream<Map<String, PrintedEntity>> get saleRequestsStream =>
      _saleRequestsStream.stream; //TODO delete this

  @override
  Future<void> loadOpenSaleRequests() async {
    //TODO delete this method
    try {
      isLoading = true;
      mainError = null;

      _webLocalSettings ??= await webLoadSettings.load();
      final deliveryControls =
          await concDeliveryControl.load(_webLocalSettings!);

      final Map<String, PrintedEntity> updatedSaleRequests =
          Map<String, PrintedEntity>.of(_saleRequestsStream.value);

      final missingCodes = deliveryControls
          .where((c) => !updatedSaleRequests.containsKey(c.PersonalizedCode))
          .map((c) => c.PersonalizedCode)
          .toSet();

      final updateCodes = deliveryControls
          .where((deliveryControl) {
            final code = deliveryControl.PersonalizedCode;
            final isLoaded = updatedSaleRequests.containsKey(code);

            if (isLoaded) {
              final currentSaleRequest = updatedSaleRequests[code]!;

              final hasUpdate =
                  deliveryControl.TotalLiquid != currentSaleRequest.TotalLiquid;

              return hasUpdate;
            }
            return true;
          })
          .map((c) => c.PersonalizedCode)
          .toSet();

      final codesToFetch = missingCodes.union(updateCodes);

      if (codesToFetch.isNotEmpty) {
        // 4. Fetch all missing items in PARALLEL (Fixes Performance)
        final results = await Future.wait(
          codesToFetch.map(
            (personalizedCode) => loadPrintedProducts.load(
              commandNumber: personalizedCode.toInt(),
              enterpriseId: _webLocalSettings!.enterpriseId,
              url:
                  '${_webLocalSettings!.defaultUrl}:${_webLocalSettings!.navsPort}',
            ),
          ),
        );

        int index = 0;
        for (final personalizedCode in codesToFetch) {
          final resultEntity = results[index];

          if (resultEntity == null) {
            index++;
            continue;
          }

          updatedSaleRequests[personalizedCode] = resultEntity;
          index++;
        }
      }

      _saleRequestsStream.subject.add(updatedSaleRequests);
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  WebLocalSettingsEntity? _webLocalSettings;
  @override
  WebLocalSettingsEntity? get webLocalSettings => _webLocalSettings;

  @override
  Future<void> updateDeliveryControlStatus({
    required int saleRequestId,
    required int deliveryLotId,
    required IsToDelivery newStatus,
  }) async {
    try {
      await concDeliveryControl.update(
        settings: _webLocalSettings!,
        saleRequestId: saleRequestId,
        deliveryLoteNumber: deliveryLotId,
        newStatus: newStatus,
      );

      await loadOpenSaleRequests();
    } catch (e) {
      mainError = getUIError(e);
    }
  }

  final _deliveryControlsStream = Rx<List<DeliveryControlEntity>>([]);
  @override
  Stream<List<DeliveryControlEntity>> get deliveryControlsStream =>
      _deliveryControlsStream.stream;

  @override
  Future<void> loadDeliveryControls() async {
    try {
      isLoading = true;
      mainError = null;

      _webLocalSettings ??= await webLoadSettings.load();
      final deliveryControls =
          await concDeliveryControl.loadWithProducts(_webLocalSettings!);

      _deliveryControlsStream.subject.add(deliveryControls);
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }
}
