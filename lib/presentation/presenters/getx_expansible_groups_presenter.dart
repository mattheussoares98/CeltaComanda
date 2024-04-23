import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:get/get.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/expansible_groups/expansible_groups.dart';
import '../mixins/mixins.dart';

class GetxExpansibleGroupsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements ExpansibleGroupsPresenter {
  final NavigateTo navigateTo;
  final LocalEnterpriseData localEnterpriseData;
  final LoadCommandsAvailable loadCommandsAvailable;

  GetxExpansibleGroupsPresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.localEnterpriseData,
    required this.loadCommandsAvailable,
  });

  late final LoadExpansibleGroups loadExpansibleGroups;
  final _expansibleGroups = Rx<List<ExpansibleGroupsViewModel>>([]);

  @override
  Stream<List<ExpansibleGroupsViewModel>> get expansibleGroupsStream =>
      _expansibleGroups.stream;

  final _saleRequestTemp = Rx<SaleRequestViewModel?>(null);
  @override
  Stream<SaleRequestViewModel?> get saleRequestTemp => _saleRequestTemp.stream;

  @override
  Future<void> load() async {
    try {
      final expansibleGroups = await loadExpansibleGroups.load();
      isLoading = true;

      if (expansibleGroups != null) {
        _expansibleGroups.subject.add(
          expansibleGroups
              .map((e) => ExpansibleGroupsViewModel(
                    Name: e.Name,
                    ExpansibleGroupId: e.ExpansibleGroupId,
                    ExpansibleGroupType: e.ExpansibleGroupType,
                    OrderClassification: e.OrderClassification,
                  ))
              .toList(),
        );
      }

      isLoading = false;
    } catch (e) {
      _expansibleGroups.subject
          .addError(UIError.unexpected.description, StackTrace.current);
      throw DomainError.unexpected;
    }
  }

  @override
  void goToProductsPage(int expansibleGroupId) {
    navigateTo.navigate(
      pageRoute: PageRoutes.products,
      arguments: expansibleGroupId,
    );
  }

  @override
  void goToCartPage() {
    navigateTo.navigate(pageRoute: PageRoutes.cart);
  }

  @override
  Future<void> goToSplashPage() async {
    navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);
  }

  @override
  Future<void> clearEnterpriseData() async {
    await localEnterpriseData.add(
      EnterpriseEntity(
        enterpriseName:
            EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
      ),
    );
    EnterpriseDataBuilder.enterpriseDataEntity = null;
  }

  @override
  Future<void> verifyCommandAvailable(String commandNumber) async {
    isLoading = true;

    try {
      SaleRequestEntity? saleRequestTemp = await loadCommandsAvailable.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: commandNumber,
      );

      if (saleRequestTemp != null) {
        _saleRequestTemp.subject.add(
          SaleRequestViewModel(
            Products:
                saleRequestTemp.Products.map((e) => ProductModel.fromEntity(e))
                    .toList(),
            PersonalizedCode: saleRequestTemp.PersonalizedCode,
            EnterpriseId: saleRequestTemp.EnterpriseId,
            TotalLiquid: saleRequestTemp.TotalLiquid,
            DeliveryControl: saleRequestTemp.DeliveryControl,
          ),
        );

        await load();
      }
    } catch (error) {
      mainError = UIError.commandNotAvailable;
    } finally {
      isLoading = false;
    }
  }
}
