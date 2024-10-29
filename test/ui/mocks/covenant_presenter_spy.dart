// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/presentation/protocols/protocols.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class CovenantPresenterSpy extends Mock implements CovenantPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  final customerErrorStreamController = StreamController<ValidationError?>();
  final customersViewModelStreamController =
      StreamController<List<CustomerViewModel>?>();
  Map<String, String?> selectedCovenantController = {};

  CovenantPresenterSpy() {
    when(() => this.mainErrorStream)
        .thenAnswer((any) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((any) => isLoadingController.stream);
    when(() => this.customerErrorStream)
        .thenAnswer((any) => customerErrorStreamController.stream);
    when(() => this.customersViewModelStream)
        .thenAnswer((any) => customersViewModelStreamController.stream);
    when(() => this.selectedCovenant)
        .thenAnswer((any) => selectedCovenantController);

    when(() => this.getCustomerByNameCodeOrCpf(
          value: any(named: "value"),
          searchByPersonalizedCode: any(named: "searchByPersonalizedCode"),
          showErrorMessageReturnedByBs:
              any(named: "showErrorMessageReturnedByBs"),
        )).thenAnswer((any) async => any);
    when(() => this.validateCustomerField(any())).thenAnswer((any) => any);
    when(() => this.updateSelectedCovenant(any(), any()))
        .thenAnswer((any) async => any);
    when(() => this.finishSaleRequestByCovenant(
          homePresenter: any(named: "homePresenter"),
          paymentPresenter: any(named: "paymentPresenter"),
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          closePagesUntilHomePage: any(named: "closePagesUntilHomePage"),
          showErrorMessageReturnedByBs:
              any(named: "showErrorMessageReturnedByBs"),
          customerPassword: any(named: "customerPassword"),
        )).thenAnswer((any) async => any);
  }
}
