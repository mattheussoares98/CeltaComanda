import 'package:flutter/foundation.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxHomePresenter with ChangeNotifier implements HomePresenter {
  final NavigateTo navigateTo;
  final LocalEnterpriseData localEnterpriseData;
  final TicketIsPermitted ticketIsPermitted;
  final LoadExpansibleGroups loadExpansibleGroups;

  GetxHomePresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.localEnterpriseData,
    required this.ticketIsPermitted,
  });

  @override
  void goToProductsPage(ExpansibleGroupEntity entity) {
    navigateTo.navigate(
      pageRoute: PageRoutes.products,
      arguments: entity,
    );
  }

  @override
  Future<void> goToSplashPage({
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
  }) async {
    navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);

    _commandNumber = null;
    expansibleGroupsPresenter.clear();
    printedProductsPresenter.clear();
    saleRequestTempPresenter.clear();
    await clearEnterpriseData();
  }

  @override
  Future<void> clearEnterpriseData() async {
    final emptyEntity = EnterpriseEntity(
      enterpriseName:
          EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName ?? "",
      enterpriseId: null,
      url: null,
      concentradorUrl: null,
    );
    EnterpriseDataBuilder.enterpriseDataEntity = emptyEntity;

    await localEnterpriseData.add(emptyEntity);
  }

  String? _commandNumber;
  @override
  String? get commandNumber => _commandNumber;
  @override
  void updateCommandNumber(String? value) {
    _commandNumber = value;
  }
}
