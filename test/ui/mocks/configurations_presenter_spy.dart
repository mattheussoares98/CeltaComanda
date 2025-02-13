import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ConfigurationsPresenterSpy extends Mock
    implements ConfigurationsPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  int? selectedPeoplesController;
  int? selectedCommandController;
  SellersViewModel? selectedSellerController;
  late List<SellersViewModel> sellersController;

  ConfigurationsPresenterSpy() {
    when(() => this.mainErrorStream)
        .thenAnswer((any) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((any) => isLoadingController.stream);
    when(() => this.selectedPeoples)
        .thenAnswer((any) => selectedPeoplesController);
    when(() => this.selectedCommand)
        .thenAnswer((any) => selectedCommandController);
    when(() => this.selectedSeller)
        .thenAnswer((any) => selectedSellerController);
    when(() => this.sellers).thenAnswer((any) => sellersController);

    when(() => this.doLogout(
          menuPresenter: any(named: "menuPresenter"),
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          cartPresenter: any(named: "cartPresenter"),
          homePresenter: any(named: "homePresenter"),
        )).thenAnswer((any) async => any);

    when(() => this.updateSelectedPeoples(any())).thenAnswer((any) => any);
    when(() => this.updateSelectedCommand(any())).thenAnswer((any) => any);
    when(() => this.updateSelectedSeller(any())).thenAnswer((any) => any);
    when(() => this.goToCancelProductsPage()).thenAnswer((any) async => any);
    when(() => this.goToSchedulesPage()).thenAnswer((any) async => any);
    when(() => this.goToSendProductsToAnotherTablePage())
        .thenAnswer((any) => any);
    when(() => this.goToParametersPage()).thenAnswer((any) async => any);
    when(() => this.goToSaleMovementsPage()).thenAnswer((any) => any);
    when(() => this.goToUpdateApplication()).thenAnswer((any) async => any);
    when(() => this.updateUsersData(
          loadLocally: any(named: "loadLocally"),
        )).thenAnswer((any) async => any);
    when(() => this.updateLoggedUser(any())).thenAnswer((any) => any);

    mockOpenOrBlockadCommand(true);
    mockLoadMenuAgain(true);
    mockUpdateCommandData(true);
    mockUpdateSaleRequestPersonalizedCode(true);
    mockCloseCommand(true);
  }

  When _mockOpenOrBlockadCommandCall() => when(() => this.openOrBlockadeCommand(
        commandNumber: any(named: "commandNumber"),
        isOpen: any(named: "isOpen"),
      ));
  void mockOpenOrBlockadCommand(bool value) {
    _mockOpenOrBlockadCommandCall().thenAnswer((any) async => value);
  }

  When _mockLoadMenuAgainCall() => when(() => this.loadMenuAgain(any()));
  void mockLoadMenuAgain(bool value) {
    _mockLoadMenuAgainCall().thenAnswer((any) async => value);
  }

  When _mockUpdateCommandDataCall() => when(() => this.loadMenuAgain(any()));
  void mockUpdateCommandData(bool value) =>
      _mockUpdateCommandDataCall().thenAnswer((any) async => value);

  When _mockUpdateSaleRequestPersonalizedCodeCall() =>
      when(() => this.updateSaleRequestPersonalizedCode(
            oldPersonalizedCode: any(named: "oldPersonalizedCode"),
            newPersonalizedCode: any(named: "newPersonalizedCode"),
          ));
  void mockUpdateSaleRequestPersonalizedCode(bool value) =>
      _mockUpdateSaleRequestPersonalizedCodeCall()
          .thenAnswer((any) async => value);

  When _mockCloseCommandCall() =>
      when(() => this.updateSaleRequestPersonalizedCode(
            oldPersonalizedCode: any(named: "oldPersonalizedCode"),
            newPersonalizedCode: any(named: "newPersonalizedCode"),
          ));
  void mockCloseCommand(bool value) =>
      _mockCloseCommandCall().thenAnswer((any) async => value);
}
