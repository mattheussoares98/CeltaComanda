import 'package:get/get.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

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

  WebLocalSettingsEntity? _webLocalSettings;
  @override
  WebLocalSettingsEntity? get webLocalSettings => _webLocalSettings;

  @override
  Future<void> updateDeliveryControlStatus({
    required DeliveryControlEntity deliveryControl,
    required int? deliveryLotId,
    required IsToDelivery newStatus,
  }) async {
    mainError = null;
    final currentStreamValue = _deliveryControlsStream.subject.value;
    try {
      final index = currentStreamValue?.indexWhere((e) {
        final matchId = e.Id == deliveryControl.Id;
        if (!matchId) return false;
        final matchProducts = deliveryLotId != null &&
            deliveryControl.Products?.any(
                    (x) => x.DeliveryLoteNumber == deliveryLotId) !=
                null;
        return matchId && matchProducts;
      });

      if (index != null && index != -1) {
        final optimizedUpdated = currentStreamValue
            ?.elementAt(index)
            .copyWith(isToDelivery: newStatus);
        if (optimizedUpdated != null) {
          final deliveryControls = [...currentStreamValue!];
          deliveryControls[index] = optimizedUpdated;
          _deliveryControlsStream.subject.add(deliveryControls);
        }
      }

      await concDeliveryControl.update(
        settings: _webLocalSettings!,
        deliveryControl: deliveryControl,
        deliveryLoteNumber: deliveryLotId,
        newStatus: newStatus,
      );

      await loadDeliveryControls();
    } catch (e) {
      if (currentStreamValue != null) {
        _deliveryControlsStream.subject.add(currentStreamValue);
      }
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
