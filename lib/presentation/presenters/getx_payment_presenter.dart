import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
import '../../main/builders/builders.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';

class GetxPaymentPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements PaymentPresenter {
  final Pay pay;
  final CommandInformations commandInformations;
  final ConcFinishSaleRequest finishSaleRequestConcentrador;
  final NavigateTo navigateTo;
  final UpdateSaleRequest updateSaleRequest;
  final LoadCustomer loadCustomer;
  final Validation validation;
  final CovenantLimit covenantLimit;
  final CheckPasswordByCustomerCode checkPasswordByCustomerCode;
  final ConcInsertSaleMovement concInsertSaleMovement;
  final GenerateXmlForNfce generateXmlForNfce;
  final SendSaleMovementAsNfce sendSaleMovementAsNfce;
  final CouponFiscalNumber couponFiscalNumber;
  final LoadUseUrlSatSharing loadUseUrlSatSharing;
  final DeleteSaleRequest deleteSaleRequest;

  GetxPaymentPresenter({
    required this.pay,
    required this.commandInformations,
    required this.finishSaleRequestConcentrador,
    required this.navigateTo,
    required this.updateSaleRequest,
    required this.loadCustomer,
    required this.validation,
    required this.covenantLimit,
    required this.checkPasswordByCustomerCode,
    required this.concInsertSaleMovement,
    required this.generateXmlForNfce,
    required this.sendSaleMovementAsNfce,
    required this.couponFiscalNumber,
    required this.loadUseUrlSatSharing,
    required this.deleteSaleRequest,
  });

  @override
  Future<void> callPayment({
    required double longAmountValue,
    required int portionQuantity,
    required PaymentMode paymentMode,
    required HomePresenter homePresenter,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      _lastRequestedPaymentFinalization = ConcentratorFinalizationModel(
        FinalizationId: paymentMode.finalizationId,
        Value: longAmountValue,
        ValueLiquid: longAmountValue,
        PortionQuantity: 1,
      );

      bool isValid = await commandInformations.isValidDatetime(
        commandNumber: homePresenter.commandEntity!.commandNumber!,
      );

      if (!isValid) {
        throw DomainError.blockedCommand;
      }

      await pay.pay(
        paymentMode: paymentMode,
        channel: homePresenter.isGeneratingVersionToRede
            ? Channels.rede
            : Channels.getnet,
        params: PayParams(
          longAmountValue: (longAmountValue * 100).toInt(),
          portionQuantity: portionQuantity,
        ),
      );
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.blockedCommand:
          mainError = UIError.blockedCommand;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> liquidateCommand({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function() showSuccessAndCloseUntilHomePage,
    required void Function(String error) showErrorMessageReturnedByBs,
  }) async {
    updateScreen = true;

    if (_lastRequestedPaymentFinalization != null &&
        !_successfulPayments.contains(_lastRequestedPaymentFinalization)) {
      _successfulPayments.add(_lastRequestedPaymentFinalization!);
    }
    updateScreen = false;

    if (totalPaidValue <
        printedProductsPresenter
            .getTotalLiquid(printedProductsPresenter.printed)) {
      return;
    }

    mainError = null;
    isLoading = true;
    try {
      bool useSharing = loadUseUrlSatSharing.getUse(null);
      SoapResponse? xmlReponse;

      if (_couponNumber == null) {
        _couponNumber = await couponFiscalNumber.loadLastNumber() + 1;
      } else {
        _couponNumber = _couponNumber! + 1;
      }

      if (_couponNumber == null) {
        throw Exception();
      }

      if (useSharing == false) {
        final xml = await generateXmlForNfce.generate(
          couponFiscalNumber: _couponNumber!,
          printed: PrintedModel.fromViewModel(printedProductsPresenter.printed!)
              .toEntity(),
          finalizations: _successfulPayments,
          customer: null,
          cpfCnpj: null,
          pdvNumber: homePresenter.commandEntity?.pdv?.PdvNumber?.toInt(),
          incrementValue: printedProductsPresenter.getServiceChargeValue(
            printedProductsPresenter.printed,
          ),
        );

        xmlReponse = await sendSaleMovementAsNfce.send(xml);

        if (xmlReponse.responseType == SoapResponseType.error) {
          showErrorMessageReturnedByBs(xmlReponse.response);
          return;
        }
      }

      final double serviceChargeValue = printedProductsPresenter
          .getServiceChargeValue(printedProductsPresenter.printed);

      await concInsertSaleMovement.insert(
        couponFiscalNumber: _couponNumber!,
        pdvId: homePresenter.commandEntity!.pdv!.PdvId!,
        pdvNumber: homePresenter.commandEntity!.pdv!.PdvNumber!,
        covenantCode: _selectedCustomer?.covenantCode,
        customerCode: _selectedCustomer?.customer.Code,
        cpfCnpj: null,
        incrementType: serviceChargeValue == 0 ? null : 1,
        incrementValue: serviceChargeValue == 0 ? null : serviceChargeValue,
        totalLiquid: printedProductsPresenter
            .getTotalLiquid(printedProductsPresenter.printed),
        finalizations: _successfulPayments.map((e) => e.toEntity()).toList(),
        products: printedProductsPresenter.printed!.Products,
        xmlToGenerateFiscal: useSharing == false ? xmlReponse?.response : null,
      );

      await couponFiscalNumber.save(_couponNumber!);

      _successfulPayments.clear();
      showSuccessAndCloseUntilHomePage();
      _lastRequestedPaymentFinalization = null;

      await deleteSaleRequest
          .delete(printedProductsPresenter.printed!.SaleRequestId!.toInt());
      await printedProductsPresenter.loadPrinted(
        homePresenter.commandEntity!.commandNumber!,
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  MethodChannel? _channel;
  @override
  void initPaymentResultHandler({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function() showSuccessAndCloseUntilHomePage,
    required void Function(String error) showErrorMessageReturnedByBs,
  }) {
    if (homePresenter.isGeneratingVersionToGetNet) {
      _channel = MethodChannel(Channels.getnet.name);
    } else if (homePresenter.isGeneratingVersionToRede) {
      _channel = MethodChannel(Channels.rede.name);
    } else {
      return;
    }

    _channel?.setMethodCallHandler((MethodCall call) async {
      if (homePresenter.isGeneratingVersionToRede) {
        await _treatRedeResponse(
          homePresenter,
          printedProductsPresenter,
          call,
          showSuccessAndCloseUntilHomePage,
          showErrorMessageReturnedByBs,
        );
      } else {
        await _treatGetNetResponse(
          homePresenter,
          printedProductsPresenter,
          call,
          showSuccessAndCloseUntilHomePage,
          showErrorMessageReturnedByBs,
        );
      }
    });
  }

  Future<void> _treatGetNetResponse(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
    MethodCall call,
    void Function() showSuccessAndCloseUntilHomePage,
    void Function(String error) showErrorMessageReturnedByBs,
  ) async {
    try {
      final response = GetNetResponseModel.fromJson(call.arguments);
      if (response.result == "0") {
        await liquidateCommand(
          homePresenter: homePresenter,
          printedProductsPresenter: printedProductsPresenter,
          showSuccessAndCloseUntilHomePage: showSuccessAndCloseUntilHomePage,
          showErrorMessageReturnedByBs: showErrorMessageReturnedByBs,
        );
      } else if (response.result == "1") {
        mainError = UIError.paymentDeclined;
      } else if (response.result == "2") {
        mainError = UIError.paymentCanceled;
      } else if (response.result == "3") {
        mainError = UIError.paymentFailed;
      } else if (response.result == "4") {
        mainError = UIError.paymentUnexpectedError;
      } else if (response.result == "5") {
        mainError = UIError.paymentPendant;
      } else {
        mainError = UIError.paymentUnexpectedError;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    }
  }

  Future<void> _treatRedeResponse(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
    MethodCall call,
    void Function() showSuccessAndCloseUntilHomePage,
    void Function(String error) showErrorMessageReturnedByBs,
  ) async {
    if (call.arguments == "Pagamento Autorizado") {
      try {
        await liquidateCommand(
          homePresenter: homePresenter,
          printedProductsPresenter: printedProductsPresenter,
          showSuccessAndCloseUntilHomePage: showSuccessAndCloseUntilHomePage,
          showErrorMessageReturnedByBs: showErrorMessageReturnedByBs,
        );
      } catch (e) {
        mainError = UIError.liquidadeCommandError;
      }
    } else if (call.arguments == "Pagamento Falhou") {
      mainError = UIError.paymentFailed;
    } else if (call.arguments == "Pagamento cancelado") {
      mainError = UIError.paymentCanceled;
    } else if (call.arguments == "Pagamento Recusado") {
      mainError = UIError.paymentDeclined;
    } else {
      mainError = UIError.paymentUnexpectedError;
    }
  }

  @override
  void disposePaymentResultHandler() {
    _channel?.setMethodCallHandler(null);
  }

  @override
  void goToCovenantPage() {
    navigateTo.navigate(pageRoute: PageRoutes.covenant);
  }

  @override
  double get totalPaidValue {
    if (_successfulPayments.isEmpty) {
      return 0;
    } else {
      return _successfulPayments.fold(
          0.0, (previousValue, element) => previousValue + element.Value!);
    }
  }

  @override
  double getTotalPendingValue(
    PrintedProductsPresenter printedProductsPresenter,
  ) {
    double totalLiquid = printedProductsPresenter
        .getTotalLiquid(printedProductsPresenter.printed);

    return (totalLiquid - totalPaidValue);
  }

  @override
  Future<void> getCustomerByNameCodeOrCpf({
    required String value,
    required void Function(String error) showErrorMessageReturnedByBs,
    required bool searchByPersonalizedCode,
  }) async {
    mainError = null;
    isLoading = true;
    customersViewModel = null;
    _selectedCustomer = null;

    try {
      validateCustomerField(value);

      _authorizationPendingModel = null;

      int? valueInInt = int.tryParse(value);

      SoapResponse? soapResponse;

// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName
// 4=PersonalizedCode
      if (value.isEmpty) {
        return;
      } else if (valueInInt == null) {
        soapResponse = await loadCustomer.load(
          value: value,
          searchTypeInt: 3,
        );
      } else if (searchByPersonalizedCode) {
        soapResponse = await loadCustomer.load(
          value: value,
          searchTypeInt: 4,
        );
      } else if (valueInInt.toString().length == 11 ||
          valueInInt.toString().length == 14) {
        soapResponse = await loadCustomer.load(
          value: value,
          searchTypeInt: 1,
        );
      } else {
        soapResponse = await loadCustomer.load(
          value: value,
          searchTypeInt: 2,
        );
      }

      if (soapResponse.responseType == SoapResponseType.error) {
        showErrorMessageReturnedByBs(soapResponse.response);
      } else {
        customersViewModel = json
            .decode(soapResponse.response)
            .map((e) => CustomerViewModel.fromJson(e))
            .toList()
            .cast<CustomerViewModel>();
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void validateCustomerField(String value) {
    customerError = null;
    const field = "customer";

    final formData = {field: value};
    customerError = validation.validate(field: field, input: formData);

    if (value.isEmpty) {
      customerError = ValidationError.requiredField;
    }
  }

  @override
  Future<void> updateSelectedCustomer(
    CustomerViewModel? customer,
    int? covenantCode,
  ) async {
    _authorizationPendingModel = null;

    if (customer == null) {
      _selectedCustomer = null;
    } else {
      _selectedCustomer = SelectedCustomerModel(
        customer: CustomerModel.fromViewModel(customer),
        covenantCode: covenantCode?.toInt(),
      );
    }
  }

  @override
  Future<void> finishSaleRequestByCovenant({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function(String error) showErrorMessageReturnedByBs,
    required void Function() showSuccessAndCloseUntilHomePage,
    required String? customerPassword,
    required int? cpfCnpj,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      if (customerPassword != null && customerPassword.isNotEmpty) {
        final passwordResponse = await checkPasswordByCustomerCode.validate(
          customerCode: _selectedCustomer!.customer.Code!,
          password: customerPassword,
        );
        if (passwordResponse.responseType == SoapResponseType.error) {
          showErrorMessageReturnedByBs(passwordResponse.response);
          return;
        }
      }

      double pendingValue = getTotalPendingValue(printedProductsPresenter);

      SoapResponse? authorizationSoapResponse;
      if (_authorizationPendingModel == null) {
        authorizationSoapResponse = await covenantLimit
            .authorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
          crossIdentity: EnterpriseBuilder.entity!
              .enterpriseConcentradorParametersEntity?.celtaBSCrossIdentity,
          customerCode: _selectedCustomer!.customer.Code!,
          covenantCode: _selectedCustomer!.covenantCode!,
          value: pendingValue,
        );

        _authorizationPendingModel = AuthorizationPendingModel(
          code: authorizationSoapResponse.response,
          isPending: true,
        );

        _successfulPayments.add(
          ConcentratorFinalizationModel(
            FinalizationId: FinalizationType.covenant.id,
            Value: pendingValue,
            ValueLiquid: pendingValue,
            PortionQuantity: 1,
            AuthorizationCode: authorizationSoapResponse.response,
            AuthorizationType: 2,
          ),
        );

        if (_couponNumber == null) {
          _couponNumber = await couponFiscalNumber.loadLastNumber() + 1;
        } else {
          _couponNumber = _couponNumber! + 1;
        }

        if (_couponNumber == null) {
          throw Exception();
        }
      }

      if (authorizationSoapResponse?.responseType == SoapResponseType.error) {
        showErrorMessageReturnedByBs(authorizationSoapResponse!.response);
      } else {
        bool useSharing =
            loadUseUrlSatSharing.getUse(cpfCnpj); //remove this comment
        SoapResponse? xmlReponse;

        if (useSharing == false) {
          final xml = await generateXmlForNfce.generate(
            couponFiscalNumber: _couponNumber!,
            printed:
                PrintedModel.fromViewModel(printedProductsPresenter.printed!)
                    .toEntity(),
            finalizations: _successfulPayments,
            customer: _selectedCustomer?.customer.toEntity(),
            cpfCnpj: cpfCnpj,
            pdvNumber: homePresenter.commandEntity?.pdv?.PdvNumber?.toInt(),
            incrementValue: printedProductsPresenter.getServiceChargeValue(
              printedProductsPresenter.printed,
            ),
          );

          xmlReponse = await sendSaleMovementAsNfce.send(xml);

          if (xmlReponse.responseType == SoapResponseType.error) {
            showErrorMessageReturnedByBs(xmlReponse.response);
            return;
          }
        }

        final double serviceChargeValue = printedProductsPresenter
            .getServiceChargeValue(printedProductsPresenter.printed);

        await concInsertSaleMovement.insert(
          couponFiscalNumber: _couponNumber!,
          pdvId: homePresenter.commandEntity!.pdv!.PdvId!,
          pdvNumber: homePresenter.commandEntity!.pdv!.PdvNumber!,
          covenantCode: _selectedCustomer?.covenantCode,
          customerCode: _selectedCustomer?.customer.Code,
          cpfCnpj: cpfCnpj?.toString(),
          incrementType: serviceChargeValue == 0 ? null : 1,
          incrementValue: serviceChargeValue == 0 ? null : serviceChargeValue,
          totalLiquid: printedProductsPresenter
              .getTotalLiquid(printedProductsPresenter.printed),
          finalizations: _successfulPayments.map((e) => e.toEntity()).toList(),
          products: _getProductsToInsertInConcentrator(
            printedProductsPresenter: printedProductsPresenter,
          ),
          xmlToGenerateFiscal:
              useSharing == false ? xmlReponse?.response : null,
        );

        await couponFiscalNumber.save(_couponNumber!);

        _authorizationPendingModel = null;
        _successfulPayments.clear();
        showSuccessAndCloseUntilHomePage();
        await deleteSaleRequest
            .delete(printedProductsPresenter.printed!.SaleRequestId!.toInt());
        await printedProductsPresenter
            .loadPrinted(homePresenter.commandEntity!.commandNumber!);
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  List<PrintedProductsViewModel> _getProductsToInsertInConcentrator({
    required PrintedProductsPresenter printedProductsPresenter,
  }) {
    List<PrintedProductsViewModel> products = [];

    for (var i = 0;
        i < printedProductsPresenter.printed!.Products.length;
        i++) {
      final product = printedProductsPresenter.printed!.Products[i];

      if (product.ProductIsFatherComposition == "true" &&
          product.childs.isNotEmpty) {
        products.add(
          PrintedProductsViewModel(
            Product: ProductsViewModel(
              SaleRetailPraticed: product.childs.fold("0", (previous, element) {
                return (previous.toDouble() + element.Value!.toDouble())
                    .toString();
              }),
              subgroupName: product.Product?.subgroupName,
              MaximumQuantityForSale: product.Product?.MaximumQuantityForSale,
              IsPromoCombox: product.Product?.IsPromoCombox,
              ProductComplement: product.Product?.ProductComplement,
              ProductsId: product.Product!.ProductsId,
              PriceLookupCode: product.Product!.PriceLookupCode,
              Name: product.Product!.Name,
              PackingAbbreviation: product.Product?.PackingAbbreviation,
              InternalCodeOnERP: product.Product?.InternalCodeOnERP,
              InternalCodeOfProductOnERP:
                  product.Product?.InternalCodeOfProductOnERP,
              EenterpriseId: product.Product?.EenterpriseId,
              PackingQuantity: product.Product?.PackingQuantity,
              OfferRetailPrice: product.Product?.OfferRetailPrice,
              WholeSalePrice: product.Product?.WholeSalePrice,
              WholeOfferPrice: product.Product?.WholeOfferPrice,
              OfferECommercePrice: product.Product?.OfferECommercePrice,
              SaleECommercePrice: product.Product?.SaleECommercePrice,
              LiquidCost: product.Product?.LiquidCost,
              LiquidCostMiddle: product.Product?.LiquidCostMiddle,
              LiquidCostReal: product.Product?.LiquidCostReal,
              RepositionCost: product.Product?.RepositionCost,
              RepositionCostMiddle: product.Product?.RepositionCostMiddle,
              RepositionCostReal: product.Product?.RepositionCostReal,
              IcmsAliquot: product.Product?.IcmsAliquot,
              IcmsIVAMargin: product.Product?.IcmsIVAMargin,
              IcmsReductionMargin: product.Product?.IcmsReductionMargin,
              IcmsStave: product.Product?.IcmsStave,
              PercImpNBPTState: product.Product?.PercImpNBPTState,
              PercImpNBPTMunicipal: product.Product?.PercImpNBPTMunicipal,
              CofinsType: product.Product?.CofinsType,
              PisType: product.Product?.PisType,
              ProductIsFatherComposition:
                  product.Product?.ProductIsFatherComposition,
              QuantityMinimumWholeSale:
                  product.Product?.QuantityMinimumWholeSale,
              QuantityMinimumWholeSaleByClass:
                  product.Product?.QuantityMinimumWholeSaleByClass,
              BalanceTare: product.Product?.BalanceTare,
              FamilyCode: product.Product?.FamilyCode,
              DepartmentCode: product.Product?.DepartmentCode,
              SectionCode: product.Product?.SectionCode,
              GroupCode: product.Product?.GroupCode,
              SubGroupCode: product.Product?.SubGroupCode,
              StockQuantity: product.Product?.StockQuantity,
              AllowFractionate: product.Product?.AllowFractionate,
              IsBalance: product.Product?.IsBalance,
              CanBeWeightyInPdv: product.Product?.CanBeWeightyInPdv,
              QuantityInBalance: product.Product?.QuantityInBalance,
              AllowQuantityInPdv: product.Product?.AllowQuantityInPdv,
              GoesForFastTable: product.Product?.GoesForFastTable,
              IsAlcoholicProduct: product.Product?.IsAlcoholicProduct,
              SaleRetailPrice: product.Product?.SaleRetailPrice,
              PercImpNBPTNational: product.Product?.PercImpNBPTNational,
              CofinsPercentage: product.Product?.CofinsPercentage,
              PisPercentage: product.Product?.PisPercentage,
              CFOP: product.Product?.CFOP,
              FiscalClassificationNCM: product.Product?.FiscalClassificationNCM,
              TributarySituationCode: product.Product?.TributarySituationCode,
              CSTPisCofins: product.Product?.CSTPisCofins,
              CodeClass: product.Product?.CodeClass,
              DepartmentName: product.Product?.DepartmentName,
              SectionName: product.Product?.SectionName,
              DateOfLastChanged: product.Product?.DateOfLastChanged,
              GroupName: product.Product?.GroupName,
              SaleRetailPraticedString:
                  product.Product?.SaleRetailPraticedString,
              PersonalizedCode: product.Product?.PersonalizedCode,
              EanCode: product.Product?.EanCode,
              NameComplete: product.Product?.NameComplete,
              NameReduced: product.Product?.NameReduced,
              Schedule: product.Product?.Schedule,
              childsComposition: product.Product?.childsComposition,
              suggestions: product.Product?.suggestions,
            ),
            SaleRequestProductId: product.SaleRequestProductId,
            ProductPriceLookUpCode: product.ProductPriceLookUpCode,
            Value: product.Value,
            Quantity: product.Quantity,
            QuantityString: product.QuantityString,
            UserId: product.UserId,
            DateHourOfCreation: product.DateHourOfCreation,
            IsCancelled: product.IsCancelled,
            IsDelivered: product.IsDelivered,
            IsPrinted: product.IsPrinted,
            ProductionStatus: product.ProductionStatus,
            TotalLiquid: product.TotalLiquid,
            ProductInternalCodeOnErp: product.ProductInternalCodeOnErp,
            SaleRequestId: product.SaleRequestId,
            ProductIsFatherComposition: product.ProductIsFatherComposition,
            SaleMovementProductCompositionId:
                product.SaleMovementProductCompositionId,
            UserIdOfCancellation: product.UserIdOfCancellation,
            childs: product.childs,
          ),
        );
        for (var x = 0; x < product.childs.length; x++) {
          final child = product.childs[x];
          products.add(PrintedProductsViewModel(
            Product: ProductsViewModel(
              SaleRetailPraticed: child.Value!,
              subgroupName: child.Product?.subgroupName,
              MaximumQuantityForSale: child.Product?.MaximumQuantityForSale,
              IsPromoCombox: child.Product?.IsPromoCombox,
              ProductComplement: child.Product?.ProductComplement,
              ProductsId: child.Product!.ProductsId,
              PriceLookupCode: child.Product!.PriceLookupCode,
              Name: child.Product!.Name,
              PackingAbbreviation: child.Product?.PackingAbbreviation,
              InternalCodeOnERP: child.Product?.InternalCodeOnERP,
              InternalCodeOfProductOnERP:
                  child.Product?.InternalCodeOfProductOnERP,
              EenterpriseId: child.Product?.EenterpriseId,
              PackingQuantity: child.Product?.PackingQuantity,
              OfferRetailPrice: child.Product?.OfferRetailPrice,
              WholeSalePrice: child.Product?.WholeSalePrice,
              WholeOfferPrice: child.Product?.WholeOfferPrice,
              OfferECommercePrice: child.Product?.OfferECommercePrice,
              SaleECommercePrice: child.Product?.SaleECommercePrice,
              LiquidCost: child.Product?.LiquidCost,
              LiquidCostMiddle: child.Product?.LiquidCostMiddle,
              LiquidCostReal: child.Product?.LiquidCostReal,
              RepositionCost: child.Product?.RepositionCost,
              RepositionCostMiddle: child.Product?.RepositionCostMiddle,
              RepositionCostReal: child.Product?.RepositionCostReal,
              IcmsAliquot: child.Product?.IcmsAliquot,
              IcmsIVAMargin: child.Product?.IcmsIVAMargin,
              IcmsReductionMargin: child.Product?.IcmsReductionMargin,
              IcmsStave: child.Product?.IcmsStave,
              PercImpNBPTState: child.Product?.PercImpNBPTState,
              PercImpNBPTMunicipal: child.Product?.PercImpNBPTMunicipal,
              CofinsType: child.Product?.CofinsType,
              PisType: child.Product?.PisType,
              ProductIsFatherComposition:
                  child.Product?.ProductIsFatherComposition,
              QuantityMinimumWholeSale: child.Product?.QuantityMinimumWholeSale,
              QuantityMinimumWholeSaleByClass:
                  child.Product?.QuantityMinimumWholeSaleByClass,
              BalanceTare: child.Product?.BalanceTare,
              FamilyCode: child.Product?.FamilyCode,
              DepartmentCode: child.Product?.DepartmentCode,
              SectionCode: child.Product?.SectionCode,
              GroupCode: child.Product?.GroupCode,
              SubGroupCode: child.Product?.SubGroupCode,
              StockQuantity: child.Product?.StockQuantity,
              AllowFractionate: child.Product?.AllowFractionate,
              IsBalance: child.Product?.IsBalance,
              CanBeWeightyInPdv: child.Product?.CanBeWeightyInPdv,
              QuantityInBalance: child.Product?.QuantityInBalance,
              AllowQuantityInPdv: child.Product?.AllowQuantityInPdv,
              GoesForFastTable: child.Product?.GoesForFastTable,
              IsAlcoholicProduct: child.Product?.IsAlcoholicProduct,
              SaleRetailPrice: child.Product?.SaleRetailPrice,
              PercImpNBPTNational: child.Product?.PercImpNBPTNational,
              CofinsPercentage: child.Product?.CofinsPercentage,
              PisPercentage: child.Product?.PisPercentage,
              CFOP: child.Product?.CFOP,
              FiscalClassificationNCM: child.Product?.FiscalClassificationNCM,
              TributarySituationCode: child.Product?.TributarySituationCode,
              CSTPisCofins: child.Product?.CSTPisCofins,
              CodeClass: child.Product?.CodeClass,
              DepartmentName: child.Product?.DepartmentName,
              SectionName: child.Product?.SectionName,
              DateOfLastChanged: child.Product?.DateOfLastChanged,
              GroupName: child.Product?.GroupName,
              SaleRetailPraticedString: child.Product?.SaleRetailPraticedString,
              PersonalizedCode: child.Product?.PersonalizedCode,
              EanCode: child.Product?.EanCode,
              NameComplete: child.Product?.NameComplete,
              NameReduced: child.Product?.NameReduced,
              Schedule: child.Product?.Schedule,
              childsComposition: child.Product?.childsComposition,
              suggestions: child.Product?.suggestions,
            ),
            SaleRequestProductId: child.SaleRequestProductId,
            ProductPriceLookUpCode: child.ProductPriceLookUpCode,
            Value: child.Value,
            Quantity: child.Quantity,
            QuantityString: child.QuantityString,
            UserId: child.UserId,
            DateHourOfCreation: child.DateHourOfCreation,
            IsCancelled: child.IsCancelled,
            IsDelivered: child.IsDelivered,
            IsPrinted: child.IsPrinted,
            ProductionStatus: child.ProductionStatus,
            TotalLiquid: child.TotalLiquid,
            ProductInternalCodeOnErp: child.ProductInternalCodeOnErp,
            SaleRequestId: child.SaleRequestId,
            ProductIsFatherComposition: child.ProductIsFatherComposition,
            SaleMovementProductCompositionId:
                child.SaleMovementProductCompositionId,
            UserIdOfCancellation: child.UserIdOfCancellation,
            childs: child.childs,
          ));
        }
      } else {
        products.add(product);
      }
    }

    return products;
  }

  @override
  void clearPayments() {
    _lastRequestedPaymentFinalization = null;
    _successfulPayments.clear();
  }

  ConcentratorFinalizationModel? _lastRequestedPaymentFinalization;
  @override
  ConcentratorFinalizationModel? get lastRequestedPaymentFinalization =>
      _lastRequestedPaymentFinalization;

  final _updateScreenStream = Rx<bool>(false);
  @override
  Stream<bool> get updateScreenStream => _updateScreenStream.stream;
  set updateScreen(bool value) => _updateScreenStream.value = value;

  final List<ConcentratorFinalizationModel> _successfulPayments = [];
  @override
  List<ConcentratorFinalizationModel> get successfulPayments =>
      _successfulPayments;

  final _customerError = Rx<ValidationError?>(null);
  @override
  Stream<ValidationError?> get customerErrorStream => _customerError.stream;
  set customerError(ValidationError? value) => _customerError.value = value;

  final _customersViewModel = Rx<List<CustomerViewModel>?>(null);
  @override
  Stream<List<CustomerViewModel>?> get customersViewModelStream =>
      _customersViewModel.stream;
  set customersViewModel(List<CustomerViewModel>? customer) =>
      _customersViewModel.subject.add(customer);

  SelectedCustomerModel? _selectedCustomer;
  @override
  SelectedCustomerModel? get selectedCustomer => _selectedCustomer;

  AuthorizationPendingModel? _authorizationPendingModel;

  @override
  AuthorizationPendingModel? get authorizationPendingModel =>
      _authorizationPendingModel;

  int? _couponNumber;
  @override
  int? get couponNumber => _couponNumber;
}
