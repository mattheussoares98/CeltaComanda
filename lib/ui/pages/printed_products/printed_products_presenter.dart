import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PrintedProductsPresenter
    with ChangeNotifier
    implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<String?> get alertMessageStream;
  Stream<List<CustomerViewModel>?> get customersStream;
  CustomerViewModel? get selectedCustomer;
  int get peopleQuantity;
  bool get canCancelProducts;
  CustomerViewModel? get customerInSaleRequest;
  double getTotalLiquid(PrintedViewModel? printed);
  double getSubtotal(PrintedViewModel? printed);
  double getServiceChargeValue(PrintedViewModel? printed);

  void updateCanCancelProducts(bool value);
  Future<void> loadPrinted(String commandNumber, {bool showIsLoading = true});
  void clear();
  void doOnClosePage();
  PrintedViewModel? get printed;

  Future<void> removeProduct({
    required String saleRequestProductId,
    required MenuPresenter menuPresenter,
    required CartPresenter cartPresenter,
    required String commandNumber,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  });

  Future<void> validateUserAndPermissionToCancelProducts({
    required int personalizedCode,
    required String password,
  });

  Future<void> removeServiceCharge({
    required String commandNumber,
    required PrintedViewModel printed,
  });

  Future<Uint8List?> printPrintedProducts({
    required int commandNumber,
    required int pdvNumber,
  });
  Future<void> oldPrintPrintedProducts({
    required Uint8List bitmap,
    required void Function() closePage,
  });

  void goToPrintProductsPage();
  void updatePeopleQuantity({required bool isAdding});

  void initPrinterResultHandler({
    required HomePresenter homePresenter,
    required void Function() closePageForOldPrintWay,
  });
  void disposePrinterHandler();

  Future<void> getCustomers({
    required String value,
    required void Function(String error) showErrorMessageReturnedByBs,
    required bool searchByPersonalizedCode,
  });
  void updateSelectedCustomer(CustomerViewModel? customer);
  Future<bool> updateCustomerInSaleRequest(
    HomePresenter homePresenter, {
    bool? isRemoving,
  });
}
