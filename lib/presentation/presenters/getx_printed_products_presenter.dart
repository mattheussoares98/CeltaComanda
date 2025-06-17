import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxPrintedProductsPresenter
    with ChangeNotifier, ErrorHandling
    implements PrintedProductsPresenter {
  final UserValidations userValidations;
  final LoadPrintedProducts loadPrintedProducts;
  final RemovePrintedProduct removePrintedProduct;
  final UpdateSaleRequest updateSaleRequest;
  final PrintBitmap printBitmap;
  final NavigateTo navigateTo;
  final GenerateBitmap generateBitmap;
  final LoadCustomer loadCustomer;

  GetxPrintedProductsPresenter({
    required this.userValidations,
    required this.loadPrintedProducts,
    required this.removePrintedProduct,
    required this.updateSaleRequest,
    required this.printBitmap,
    required this.navigateTo,
    required this.generateBitmap,
    required this.loadCustomer,
  });

  @override
  Future<void> removeProduct({
    required String saleRequestProductId,
    required MenuPresenter menuPresenter,
    required CartPresenter cartPresenter,
    required String commandNumber,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await removePrintedProduct.remove(saleRequestProductId);

      await loadPrinted(commandNumber);
    } catch (e) {
      await loadPrinted(commandNumber);
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> loadPrinted(String commandNumber,
      {bool showIsLoading = true}) async {
    if (showIsLoading) {
      isLoading = true;
    }
    mainError = null;

    try {
      PrintedEntity? printedProducts = await loadPrintedProducts.load(
        commandNumber: commandNumber.toInt(),
      );

      _printed = null;
      if (printedProducts?.Products.isEmpty == false) {
        _printed = PrintedViewModel.fromEntity(printedProducts!);
        _printed!.Products.sort((a, b) => DateTime.parse(a.DateHourOfCreation!)
            .compareTo(DateTime.parse(b.DateHourOfCreation!)));
      }

      if (_printed?.CustomerCode == null ||
          _printed?.CustomerCode?.toInt() == 0) {
        _customerInSaleRequest = null;
      } else if (_printed?.CustomerCode != _customerInSaleRequest?.Code) {
        final response = await loadCustomer.load(
          value: _printed!.CustomerCode!,
          searchByPersonalizedCode: false,
        );

        _customerInSaleRequest = CustomerViewModel.fromJson(
          json.decode(response).first,
        );
      }
    } on BsError catch (e) {
      mainError = UIError.custom(e.toString());
      _customerInSaleRequest = null;
    } catch (error) {
      switch (error) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
          throw DomainError.commandNotAvailable;
        default:
          mainError = UIError.unexpected;
          throw DomainError.unexpected;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void clear() {
    _printed = null;
  }

  @override
  Future<void> validateUserAndPermissionToCancelProducts({
    required int personalizedCode,
    required String password,
  }) async {
    isLoading = true;
    mainError = null;
    alertMessage = null;
    updateCanCancelProducts(false);

    try {
      final isValidPassword = await userValidations.isValidPassword(
        url: EnterpriseBuilder.entity!.url!,
        personalizedCode: personalizedCode,
        password: password,
      );

      if (!isValidPassword) {
        throw DomainError.invalidCredentials;
      }

      if (isValidPassword) {
        updateCanCancelProducts(
          await userValidations.canCancel(
            personalizedCode: personalizedCode,
            url: EnterpriseBuilder.entity!.url!,
          ),
        );
      }
      if (!canCancelProducts) {
        throw DomainError.accessDenied;
      }

      if (canCancelProducts) {
        updateCanCancelProducts(true);
        alertMessage = R.string.msgSuccessToCancelProducts;
      }
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  PrintedViewModel? _printed;
  @override
  PrintedViewModel? get printed => _printed;

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) => _isLoading.value = value;

  final _mainError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;

  bool _canCancelProducts = false;
  @override
  bool get canCancelProducts => _canCancelProducts;

  int _peopleQuantity = 1;
  @override
  int get peopleQuantity => _peopleQuantity;
  set peopleQuantity(int value) => _peopleQuantity = value;

  @override
  void updateCanCancelProducts(bool value) {
    _canCancelProducts = value;
    notifyListeners();
  }

  final _alertMessage = Rx<String?>(null);
  @override
  Stream<String?> get alertMessageStream => _alertMessage.stream;
  set alertMessage(String? value) => _alertMessage.value = value;

  @override
  void doOnClosePage() {
    _canCancelProducts = false;
    _peopleQuantity = 1;
  }

  @override
  double getTotalLiquid(PrintedViewModel? printed) {
    if (printed == null) {
      return 0;
    }

    return (printed.TotalLiquid!.toDouble() + getServiceChargeValue(printed))
        .toStringAsFixed(2)
        .toDouble();
  }

  @override
  double getSubtotal(PrintedViewModel? printed) {
    if (printed == null) {
      return 0;
    }

    return printed.TotalLiquid!.toDouble();
  }

  @override
  double getServiceChargeValue(PrintedViewModel? printed) {
    if (printed == null) {
      return 0;
    }

    double value;

    if (printed.IncrementType?.toInt() == 1) {
      //value
      value = printed.IncrementValue!.toDouble();
    } else if (printed.IncrementType?.toInt() == 2) {
      //percentage
      value = printed.TotalLiquid!.toDouble() *
          ((EnterpriseBuilder.entity!.serviceChargePercentageOrValue ?? 0) /
              100);
    } else {
      return 0;
    }

    return value;
  }

  @override
  Future<void> removeServiceCharge({
    required String commandNumber,
    required PrintedViewModel printed,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final model = SaleRequestModel(
        CovenantCode: null,
        CustomerCode: null,
        IncrementType: 0,
        IncrementValue: 0,
        PlaceId: printed.PlaceId,
        TotalLiquid: printed.TotalLiquid!.toDouble(),
        EnterpriseId: EnterpriseBuilder.entity?.enterpriseId,
      );

      await updateSaleRequest.update(
        model: model,
        commandNumber: commandNumber.padLeft(3, "0"),
        saleRequestId: printed.SaleRequestId!.toInt(),
      );

      await loadPrinted(commandNumber);
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> oldPrintPrintedProducts({
    required Uint8List bitmap,
    required void Function() closePage,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await printBitmap.print(bitmap);
    } catch (e) {
      mainError = UIError.unexpected;
      closePage();
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<Uint8List?> printPrintedProducts({
    required int commandNumber,
    required int pdvNumber,
  }) async {
    if (EnterpriseBuilder.entity?.useOldPrintWay == true) {
      navigateTo.navigate(pageRoute: PageRoutes.printProducts);
      return null;
    }
    isLoading = true;
    mainError = null;

    try {
      final bitmap = await generateBitmap.generate(
        commandNumber: commandNumber,
        pdvNumber: pdvNumber,
        printed: _printed!,
        subTotal: getSubtotal(printed),
        serviceChargeValue: getServiceChargeValue(printed),
        totalLiquid: getTotalLiquid(printed),
        peopleQuantity: peopleQuantity,
      );
      await printBitmap.print(bitmap);
      return bitmap;
    } catch (e) {
      mainError = getUIError(e);
      return null;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> goToPrintProductsPage() async {
    await navigateTo.navigate(pageRoute: PageRoutes.printProducts);
    //TODO remove this function if new print works
  }

  @override
  void updatePeopleQuantity({required bool isAdding}) {
    if (isAdding) {
      _peopleQuantity++;
    } else if (_peopleQuantity > 1) {
      _peopleQuantity--;
    }
  }

  MethodChannel? _channel;
  @override
  void initPrinterResultHandler({
    required HomePresenter homePresenter,
    required void Function() closePageForOldPrintWay,
  }) {
    if (homePresenter.isGeneratingVersionToRede ||
        homePresenter.isGeneratingVersionToGetNet) {
      _channel = MethodChannel(Channels.printer.name);
    } else {
      return;
    }

    _channel?.setMethodCallHandler((MethodCall call) async {
      if (call.arguments == "Success") {
        isLoading = false;
      } else {
        mainError = UIError.unexpected;
        isLoading = false;
      }
    });
  }

  @override
  void disposePrinterHandler() {
    _channel?.setMethodCallHandler(null);
  }

  final _customers = Rx<List<CustomerViewModel>?>(null);
  @override
  Stream<List<CustomerViewModel>?> get customersStream => _customers.stream;
  set customers(List<CustomerViewModel>? customers) =>
      _customers.value = customers;

  final _selectedCustomer = Rx<CustomerViewModel?>(null);
  @override
  CustomerViewModel? get selectedCustomer => _selectedCustomer.value;

  @override
  Future<void> getCustomers({
    required String value,
    required void Function(String error) showErrorMessageReturnedByBs,
    required bool searchByPersonalizedCode,
  }) async {
    isLoading = true;
    mainError = null;
    customers = null;
    _selectedCustomer.value = null;

    try {
      final soapResponse = await loadCustomer.load(
        value: value,
        searchByPersonalizedCode: searchByPersonalizedCode,
      );

      customers = (json.decode(soapResponse) as List)
          .map((e) => CustomerViewModel.fromJson(e))
          .toList()
          .cast<CustomerViewModel>();
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateSelectedCustomer(CustomerViewModel? customer) {
    if (customer == _selectedCustomer.value) {
      _selectedCustomer.value = null;
    } else {
      _selectedCustomer.value = customer;
    }
  }

  @override
  Future<bool> updateCustomerInSaleRequest(
    HomePresenter homePresenter, {
    bool? isRemoving,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (isRemoving == true) {
        //continue
      } else if (_selectedCustomer.value?.Code == null) {
        throw DomainError.selectCustomer;
      } else if (_printed?.SaleRequestId == null ||
          homePresenter.commandEntity?.commandNumber == null) {
        throw DomainError.unexpected;
      }

      await updateSaleRequest.update(
        commandNumber: homePresenter.commandEntity!.commandNumber!,
        saleRequestId: _printed!.SaleRequestId!.toInt(),
        model: SaleRequestModel(
          CovenantCode: null,
          CustomerCode:
              isRemoving == true ? 0 : _selectedCustomer.value!.Code!.toInt(),
          TotalLiquid: printed!.TotalLiquid!.toDouble(),
          PlaceId: printed?.PlaceId,
          EnterpriseId: EnterpriseBuilder.entity?.enterpriseId,
        ),
      );

      _selectedCustomer.value = null;

      await loadPrinted(homePresenter.commandEntity!.commandNumber!);

      return true;
    } catch (e) {
      mainError = getUIError(e);
      return false;
    } finally {
      isLoading = false;
    }
  }

  CustomerViewModel? _customerInSaleRequest;
  @override
  CustomerViewModel? get customerInSaleRequest => _customerInSaleRequest;
}
