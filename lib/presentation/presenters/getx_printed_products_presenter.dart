import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxPrintedProductsPresenter
    with ChangeNotifier
    implements PrintedProductsPresenter {
  final UserValidations userValidations;
  final LoadPrintedProducts loadPrintedProducts;
  final RemovePrintedProduct removePrintedProduct;
  final UpdateSaleRequest updateSaleRequest;
  final PrintBitmap printBitmap;
  final NavigateTo navigateTo;

  GetxPrintedProductsPresenter({
    required this.userValidations,
    required this.loadPrintedProducts,
    required this.removePrintedProduct,
    required this.updateSaleRequest,
    required this.printBitmap,
    required this.navigateTo,
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
    } on DomainError catch (error) {
      await loadPrinted(commandNumber);
      switch (error) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
        default:
          mainError = UIError.unexpected;
      }
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
        _printed!.Products.sort((a, b) => DateTime.parse(a.DateHourOfCreation)
            .compareTo(DateTime.parse(b.DateHourOfCreation)));
      }
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
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentialsOrAccessDenied:
          mainError = UIError.invalidCredentialsOrAccessDenied;
        case DomainError.accessDenied:
          mainError = UIError.accessDenied;
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
        default:
          mainError = UIError.unexpected;
      }
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

    return printed.TotalLiquid.toDouble() + getServiceChargeValue(printed);
  }

  @override
  double getSubtotal(PrintedViewModel? printed) {
    if (printed == null) {
      return 0;
    }

    return printed.TotalLiquid.toDouble();
  }

  @override
  double getServiceChargeValue(PrintedViewModel? printed) {
    if (printed == null) {
      return 0;
    }

    double value;

    if (printed.IncrementType.toInt() == 1) {
      //value
      value = printed.IncrementValue.toDouble();
    } else if (printed.IncrementType.toInt() == 2) {
      //percentage
      value = printed.TotalLiquid.toDouble() *
          (EnterpriseBuilder.entity!.serviceChargePercentageOrValue! / 100);
    } else if (EnterpriseBuilder.entity?.pluServiceCharge != null &&
        EnterpriseBuilder.entity?.internalCodeOnErpServiceCharge != null) {
      return 0;
    } else {
      return 0;
    }

    return value.roundAccordingBs();
  }

  @override
  Future<void> removeServiceCharge({
    required int userPersonalizedCode,
    required String password,
    required String commandNumber,
    required PrintedViewModel printed,
    required bool validateUserAndPassword,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      if (validateUserAndPassword) {
        bool isValid = await userValidations.isValidPassword(
          url: EnterpriseBuilder.entity!.url!,
          personalizedCode: userPersonalizedCode,
          password: password,
        );

        if (!isValid) {
          throw DomainError.invalidCredentialsOrAccessDenied;
        }
      }

      final model = SaleRequestModel(
        CovenantCode: null,
        CustomerCode: null,
        IncrementType: 0,
        IncrementValue: 0,
        TotalLiquid: printed.TotalLiquid.toDouble(),
        EnterpriseId: EnterpriseBuilder.entity?.enterpriseId,
      );

      await updateSaleRequest.update(
        model: model,
        commandNumber: commandNumber.padLeft(3, "0"),
        saleRequestId: printed.SaleRequestId.toInt(),
      );

      await loadPrinted(commandNumber);
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.invalidCredentialsOrAccessDenied:
          mainError = UIError.invalidCredentialsOrAccessDenied;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> printPrintedProducts({
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
  Future<void> goToPrintProductsPage() async {
    await navigateTo.navigate(pageRoute: PageRoutes.printProducts);
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
    required void Function() closePage,
  }) {
    if (homePresenter.isGeneratingVersionToRede) {
      _channel = MethodChannel(Channels.redePrinter.name);
    } else {
      return;
    }

    _channel?.setMethodCallHandler((MethodCall call) async {
      if (call.arguments == "Success") {
        closePage();
        debugPrint("Success");
      } else {
        closePage();
        debugPrint("Error");
      }
    });
  }

  @override
  void disposePrinterHandler() {
    _channel?.setMethodCallHandler(null);
  }
}
