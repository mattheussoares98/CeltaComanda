import 'entities.dart';

class EnterpriseConcentradorParametersEntity {
  int? parametersId;
  bool? useBalanceOnPdv;
  int? balanceLabelProductCodeSize;
  bool? balanceLabelProductCodeWithCheckerDigit;
  int? balanceLabelValueOrQuantityType;
  int? roundingType;
  bool? allowDiscountOnOffer;
  bool? allowDiscountOnWholeSale;
  bool? allowManualDiscountOnAutomaticDiscount;
  bool? useDiscountLiquidFromSaleNegotiation;
  bool? acceptCheckCustomerNotKnow;
  bool? useFinalizationCheckLikePortion;
  int? internalCustomerCode;
  dynamic productInternalCodeToDonation;
  bool? allowParcelling;
  bool? openCashDrawerOnlyForMoney;
  bool? showValuesOnBleeding;
  bool? showOnlyCardValuesOnBleeding;
  bool? showPOSValuesOnBleeding;
  bool? limitValueToBleedByCashierBalanceValues;
  bool? blockadeCashierOnLimitBleedingExceed;
  bool? considerBottomCashierValueOnBleeding;
  bool? askSaleIsTravel;
  bool? useDeliveryControl;
  bool? useDeliveryControlFastTable;
  bool? useDeliveryControlAskFlagNumber;
  bool? requestCustomerToDeliveryType;
  bool? useGiftControl;
  bool? separateDeliveryControlPayments;
  bool? controlCashDrawerOpened;
  int? allowCancelOnlyLastSale;
  bool? allowCancelAllItensOnCoupon;
  bool? blockadeSaleRequestTaxPayerInterState;
  bool? blockadeSaleRequestNotPrint;
  bool? obligatoryCovenantWhenCustomer;
  int? printCouponModel;
  int? printCouponTEFOrder;
  int? useMotiveCancellationType;
  int? useMotiveJustificationTypeOnBleeding;
  int? useMotiveJustificationTypeOnSaleDiscount;
  int? discountTypeAllowed;
  bool? printProductCancelledAfterSale;
  String? balanceMask;
  dynamic sitefMsgVisor;
  dynamic sitefIPNumber;
  dynamic sitefEnterpriseCode;
  dynamic sitefCustomerCode;
  dynamic sitefCliSitefAdditionalDataIni;
  int? digitalWalletShowQRCodePayment;
  int? consumerCPFCNPJRequestType;
  int? saleRequestSellerRequestType;
  int? saleRequestOrigin;
  int? finalizationPOSRequestNSUType;
  bool? paymentFinalizationSelectMoneyAutomatically;
  bool? fillAutomaticallyCPFCNPJWithCustomerData;
  int? parcelMaxPortionsNumber;
  bool? showPortionsNumberWithGride;
  String? celtaBSUrlCCS;
  String? celtaBSUrlBSF;
  String? celtaBSCrossIdentity;
  dynamic mercaFacilDiscountsTokenApi;
  bool? mercaFacilDiscountsIsEnabled;
  dynamic bonifiQUser;
  dynamic bonifiQPassword;
  bool? bonifiQIsEnabled;
  dynamic cresceVendasUser;
  dynamic cresceVendasPassword;
  bool? cresceVendasIsEnabled;
  dynamic cupomMsgBottom;
  dynamic cupomMsgExchangeInformation;
  int? pdvAspectViwModelType;
  String? saleMsgInitial;
  bool? useCupomPrintSimplify;
  bool? useCupomPrintAllProductName;
  bool? printDiscountProductsOnCoupon;
  bool? allowNFCeEmission;
  dynamic pathToGenerateXmlSATNFCe;
  bool? productSearchPluCodeWithDigit;
  bool? disableSearchDotProductDigit;
  bool? disableSearchPluForProductEan;
  bool? showStockValueOnProductConsult;
  int? saleProductMaxQtdItem;
  dynamic saleProductBalanceMaxQtdItem;
  dynamic imageMarketingSecondsForIdleTime;
  dynamic imageMarketingSecondsForShowEachImage;
  bool? allowMaxQtdItemExceedAuthorization;
  int? urlSATSharingTotalCouponGroup;
  bool? sATSharingBlockadeForTEF;
  bool? sATSharingBlockadeForCustomerIdentifier;
  EnterpriseConcentradorEntity? enterprise;
  bool? requestSalePriceTypeOnInitialSale;
  bool? showWholeSalePriceOnProductConsult;
  int? daysToMaintainHistory;
  int? bleedingPrintNumber;
  int? printNumberForPOSVoucher;
  int? printNumberForCovenantVoucher;
  int? printNumberForCreditDevolutionVoucher;
  int? printNumberForExchangeInformation;
  int? printNumberForDeliveryVoucher;
  bool? showCustomerAddress;
  bool? showCustomerTelephone;
  bool? activePromotionChampionMarks;
  bool? tEFRequestOriginParceling;
  bool? useControlCashierClose;
  bool? use24HsCashierMovement;
  int? userAuthenticationModelType;
  bool? xavierCardIsEnabled;
  dynamic xavierCardUrl;
  dynamic xavierCardEnterpriseCode;
  dynamic xavierCardUserCode;
  dynamic xavierCardUserPassword;
  bool? vidaMaisCardIsEnabled;
  dynamic vidaMaisCardUserCode;
  dynamic vidaMaisCardUserPassword;
  dynamic vidaMaisCardSellerCode;
  int? parkingControlType;
  dynamic parkingControlIPAddress;
  int? parkingControlIPPort;

  EnterpriseConcentradorParametersEntity(
      {this.parametersId,
      this.useBalanceOnPdv,
      this.balanceLabelProductCodeSize,
      this.balanceLabelProductCodeWithCheckerDigit,
      this.balanceLabelValueOrQuantityType,
      this.roundingType,
      this.allowDiscountOnOffer,
      this.allowDiscountOnWholeSale,
      this.allowManualDiscountOnAutomaticDiscount,
      this.useDiscountLiquidFromSaleNegotiation,
      this.acceptCheckCustomerNotKnow,
      this.useFinalizationCheckLikePortion,
      this.internalCustomerCode,
      this.productInternalCodeToDonation,
      this.allowParcelling,
      this.openCashDrawerOnlyForMoney,
      this.showValuesOnBleeding,
      this.showOnlyCardValuesOnBleeding,
      this.showPOSValuesOnBleeding,
      this.limitValueToBleedByCashierBalanceValues,
      this.blockadeCashierOnLimitBleedingExceed,
      this.considerBottomCashierValueOnBleeding,
      this.askSaleIsTravel,
      this.useDeliveryControl,
      this.useDeliveryControlFastTable,
      this.useDeliveryControlAskFlagNumber,
      this.requestCustomerToDeliveryType,
      this.useGiftControl,
      this.separateDeliveryControlPayments,
      this.controlCashDrawerOpened,
      this.allowCancelOnlyLastSale,
      this.allowCancelAllItensOnCoupon,
      this.blockadeSaleRequestTaxPayerInterState,
      this.blockadeSaleRequestNotPrint,
      this.obligatoryCovenantWhenCustomer,
      this.printCouponModel,
      this.printCouponTEFOrder,
      this.useMotiveCancellationType,
      this.useMotiveJustificationTypeOnBleeding,
      this.useMotiveJustificationTypeOnSaleDiscount,
      this.discountTypeAllowed,
      this.printProductCancelledAfterSale,
      this.balanceMask,
      this.sitefMsgVisor,
      this.sitefIPNumber,
      this.sitefEnterpriseCode,
      this.sitefCustomerCode,
      this.sitefCliSitefAdditionalDataIni,
      this.digitalWalletShowQRCodePayment,
      this.consumerCPFCNPJRequestType,
      this.saleRequestSellerRequestType,
      this.saleRequestOrigin,
      this.finalizationPOSRequestNSUType,
      this.paymentFinalizationSelectMoneyAutomatically,
      this.fillAutomaticallyCPFCNPJWithCustomerData,
      this.parcelMaxPortionsNumber,
      this.showPortionsNumberWithGride,
      this.celtaBSUrlCCS,
      this.celtaBSUrlBSF,
      this.celtaBSCrossIdentity,
      this.mercaFacilDiscountsTokenApi,
      this.mercaFacilDiscountsIsEnabled,
      this.bonifiQUser,
      this.bonifiQPassword,
      this.bonifiQIsEnabled,
      this.cresceVendasUser,
      this.cresceVendasPassword,
      this.cresceVendasIsEnabled,
      this.cupomMsgBottom,
      this.cupomMsgExchangeInformation,
      this.pdvAspectViwModelType,
      this.saleMsgInitial,
      this.useCupomPrintSimplify,
      this.useCupomPrintAllProductName,
      this.printDiscountProductsOnCoupon,
      this.allowNFCeEmission,
      this.pathToGenerateXmlSATNFCe,
      this.productSearchPluCodeWithDigit,
      this.disableSearchDotProductDigit,
      this.disableSearchPluForProductEan,
      this.showStockValueOnProductConsult,
      this.saleProductMaxQtdItem,
      this.saleProductBalanceMaxQtdItem,
      this.imageMarketingSecondsForIdleTime,
      this.imageMarketingSecondsForShowEachImage,
      this.allowMaxQtdItemExceedAuthorization,
      this.urlSATSharingTotalCouponGroup,
      this.sATSharingBlockadeForTEF,
      this.sATSharingBlockadeForCustomerIdentifier,
      this.enterprise,
      this.requestSalePriceTypeOnInitialSale,
      this.showWholeSalePriceOnProductConsult,
      this.daysToMaintainHistory,
      this.bleedingPrintNumber,
      this.printNumberForPOSVoucher,
      this.printNumberForCovenantVoucher,
      this.printNumberForCreditDevolutionVoucher,
      this.printNumberForExchangeInformation,
      this.printNumberForDeliveryVoucher,
      this.showCustomerAddress,
      this.showCustomerTelephone,
      this.activePromotionChampionMarks,
      this.tEFRequestOriginParceling,
      this.useControlCashierClose,
      this.use24HsCashierMovement,
      this.userAuthenticationModelType,
      this.xavierCardIsEnabled,
      this.xavierCardUrl,
      this.xavierCardEnterpriseCode,
      this.xavierCardUserCode,
      this.xavierCardUserPassword,
      this.vidaMaisCardIsEnabled,
      this.vidaMaisCardUserCode,
      this.vidaMaisCardUserPassword,
      this.vidaMaisCardSellerCode,
      this.parkingControlType,
      this.parkingControlIPAddress,
      this.parkingControlIPPort});

  EnterpriseConcentradorParametersEntity.fromJson(Map<String, dynamic> json) {
    parametersId = json['ParametersId'];
    useBalanceOnPdv = json['UseBalanceOnPdv'];
    balanceLabelProductCodeSize = json['BalanceLabelProductCodeSize'];
    balanceLabelProductCodeWithCheckerDigit =
        json['BalanceLabelProductCodeWithCheckerDigit'];
    balanceLabelValueOrQuantityType = json['BalanceLabelValueOrQuantityType'];
    roundingType = json['RoundingType'];
    allowDiscountOnOffer = json['AllowDiscountOnOffer'];
    allowDiscountOnWholeSale = json['AllowDiscountOnWholeSale'];
    allowManualDiscountOnAutomaticDiscount =
        json['AllowManualDiscountOnAutomaticDiscount'];
    useDiscountLiquidFromSaleNegotiation =
        json['UseDiscountLiquidFromSaleNegotiation'];
    acceptCheckCustomerNotKnow = json['AcceptCheckCustomerNotKnow'];
    useFinalizationCheckLikePortion = json['UseFinalizationCheckLikePortion'];
    internalCustomerCode = json['InternalCustomerCode'];
    productInternalCodeToDonation = json['ProductInternalCodeToDonation'];
    allowParcelling = json['AllowParcelling'];
    openCashDrawerOnlyForMoney = json['OpenCashDrawerOnlyForMoney'];
    showValuesOnBleeding = json['ShowValuesOnBleeding'];
    showOnlyCardValuesOnBleeding = json['ShowOnlyCardValuesOnBleeding'];
    showPOSValuesOnBleeding = json['ShowPOSValuesOnBleeding'];
    limitValueToBleedByCashierBalanceValues =
        json['LimitValueToBleedByCashierBalanceValues'];
    blockadeCashierOnLimitBleedingExceed =
        json['BlockadeCashierOnLimitBleedingExceed'];
    considerBottomCashierValueOnBleeding =
        json['ConsiderBottomCashierValueOnBleeding'];
    askSaleIsTravel = json['AskSaleIsTravel'];
    useDeliveryControl = json['UseDeliveryControl'];
    useDeliveryControlFastTable = json['UseDeliveryControlFastTable'];
    useDeliveryControlAskFlagNumber = json['UseDeliveryControlAskFlagNumber'];
    requestCustomerToDeliveryType = json['RequestCustomerToDeliveryType'];
    useGiftControl = json['UseGiftControl'];
    separateDeliveryControlPayments = json['SeparateDeliveryControlPayments'];
    controlCashDrawerOpened = json['ControlCashDrawerOpened'];
    allowCancelOnlyLastSale = json['AllowCancelOnlyLastSale'];
    allowCancelAllItensOnCoupon = json['AllowCancelAllItensOnCoupon'];
    blockadeSaleRequestTaxPayerInterState =
        json['BlockadeSaleRequestTaxPayerInterState'];
    blockadeSaleRequestNotPrint = json['BlockadeSaleRequestNotPrint'];
    obligatoryCovenantWhenCustomer = json['ObligatoryCovenantWhenCustomer'];
    printCouponModel = json['PrintCouponModel'];
    printCouponTEFOrder = json['PrintCouponTEFOrder'];
    useMotiveCancellationType = json['UseMotiveCancellationType'];
    useMotiveJustificationTypeOnBleeding =
        json['UseMotiveJustificationTypeOnBleeding'];
    useMotiveJustificationTypeOnSaleDiscount =
        json['UseMotiveJustificationTypeOnSaleDiscount'];
    discountTypeAllowed = json['DiscountTypeAllowed'];
    printProductCancelledAfterSale = json['PrintProductCancelledAfterSale'];
    balanceMask = json['BalanceMask'];
    sitefMsgVisor = json['SitefMsgVisor'];
    sitefIPNumber = json['SitefIPNumber'];
    sitefEnterpriseCode = json['SitefEnterpriseCode'];
    sitefCustomerCode = json['SitefCustomerCode'];
    sitefCliSitefAdditionalDataIni = json['SitefCliSitefAdditionalDataIni'];
    digitalWalletShowQRCodePayment = json['DigitalWalletShowQRCodePayment'];
    consumerCPFCNPJRequestType = json['ConsumerCPFCNPJRequestType'];
    saleRequestSellerRequestType = json['SaleRequestSellerRequestType'];
    saleRequestOrigin = json['SaleRequestOrigin'];
    finalizationPOSRequestNSUType = json['FinalizationPOSRequestNSUType'];
    paymentFinalizationSelectMoneyAutomatically =
        json['PaymentFinalizationSelectMoneyAutomatically'];
    fillAutomaticallyCPFCNPJWithCustomerData =
        json['FillAutomaticallyCPFCNPJWithCustomerData'];
    parcelMaxPortionsNumber = json['ParcelMaxPortionsNumber'];
    showPortionsNumberWithGride = json['ShowPortionsNumberWithGride'];
    celtaBSUrlCCS = json['CeltaBSUrlCCS'];
    celtaBSUrlBSF = json['CeltaBSUrlBSF'];
    celtaBSCrossIdentity = json['CeltaBSCrossIdentity'];
    mercaFacilDiscountsTokenApi = json['MercaFacilDiscountsTokenApi'];
    mercaFacilDiscountsIsEnabled = json['MercaFacilDiscountsIsEnabled'];
    bonifiQUser = json['BonifiQUser'];
    bonifiQPassword = json['BonifiQPassword'];
    bonifiQIsEnabled = json['BonifiQIsEnabled'];
    cresceVendasUser = json['CresceVendasUser'];
    cresceVendasPassword = json['CresceVendasPassword'];
    cresceVendasIsEnabled = json['CresceVendasIsEnabled'];
    cupomMsgBottom = json['CupomMsgBottom'];
    cupomMsgExchangeInformation = json['CupomMsgExchangeInformation'];
    pdvAspectViwModelType = json['PdvAspectViwModelType'];
    saleMsgInitial = json['SaleMsgInitial'];
    useCupomPrintSimplify = json['UseCupomPrintSimplify'];
    useCupomPrintAllProductName = json['UseCupomPrintAllProductName'];
    printDiscountProductsOnCoupon = json['PrintDiscountProductsOnCoupon'];
    allowNFCeEmission = json['AllowNFCeEmission'];
    pathToGenerateXmlSATNFCe = json['PathToGenerateXmlSATNFCe'];
    productSearchPluCodeWithDigit = json['ProductSearchPluCodeWithDigit'];
    disableSearchDotProductDigit = json['DisableSearchDotProductDigit'];
    disableSearchPluForProductEan = json['DisableSearchPluForProductEan'];
    showStockValueOnProductConsult = json['ShowStockValueOnProductConsult'];
    saleProductMaxQtdItem = json['SaleProductMaxQtdItem'];
    saleProductBalanceMaxQtdItem = json['SaleProductBalanceMaxQtdItem'];
    imageMarketingSecondsForIdleTime = json['ImageMarketingSecondsForIdleTime'];
    imageMarketingSecondsForShowEachImage =
        json['ImageMarketingSecondsForShowEachImage'];
    allowMaxQtdItemExceedAuthorization =
        json['AllowMaxQtdItemExceedAuthorization'];
    urlSATSharingTotalCouponGroup = json['UrlSATSharingTotalCouponGroup'];
    sATSharingBlockadeForTEF = json['SATSharingBlockadeForTEF'];
    sATSharingBlockadeForCustomerIdentifier =
        json['SATSharingBlockadeForCustomerIdentifier'];
    enterprise = json['Enterprise'] != null
        ? EnterpriseConcentradorEntity.fromJson(json['Enterprise'])
        : null;
    requestSalePriceTypeOnInitialSale =
        json['RequestSalePriceTypeOnInitialSale'];
    showWholeSalePriceOnProductConsult =
        json['ShowWholeSalePriceOnProductConsult'];
    daysToMaintainHistory = json['DaysToMaintainHistory'];
    bleedingPrintNumber = json['BleedingPrintNumber'];
    printNumberForPOSVoucher = json['PrintNumberForPOSVoucher'];
    printNumberForCovenantVoucher = json['PrintNumberForCovenantVoucher'];
    printNumberForCreditDevolutionVoucher =
        json['PrintNumberForCreditDevolutionVoucher'];
    printNumberForExchangeInformation =
        json['PrintNumberForExchangeInformation'];
    printNumberForDeliveryVoucher = json['PrintNumberForDeliveryVoucher'];
    showCustomerAddress = json['ShowCustomerAddress'];
    showCustomerTelephone = json['ShowCustomerTelephone'];
    activePromotionChampionMarks = json['ActivePromotionChampionMarks'];
    tEFRequestOriginParceling = json['TEFRequestOriginParceling'];
    useControlCashierClose = json['UseControlCashierClose'];
    use24HsCashierMovement = json['Use24HsCashierMovement'];
    userAuthenticationModelType = json['UserAuthenticationModelType'];
    xavierCardIsEnabled = json['XavierCardIsEnabled'];
    xavierCardUrl = json['XavierCardUrl'];
    xavierCardEnterpriseCode = json['XavierCardEnterpriseCode'];
    xavierCardUserCode = json['XavierCardUserCode'];
    xavierCardUserPassword = json['XavierCardUserPassword'];
    vidaMaisCardIsEnabled = json['VidaMaisCardIsEnabled'];
    vidaMaisCardUserCode = json['VidaMaisCardUserCode'];
    vidaMaisCardUserPassword = json['VidaMaisCardUserPassword'];
    vidaMaisCardSellerCode = json['VidaMaisCardSellerCode'];
    parkingControlType = json['ParkingControlType'];
    parkingControlIPAddress = json['ParkingControlIPAddress'];
    parkingControlIPPort = json['ParkingControlIPPort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ParametersId'] = parametersId;
    data['UseBalanceOnPdv'] = useBalanceOnPdv;
    data['BalanceLabelProductCodeSize'] = balanceLabelProductCodeSize;
    data['BalanceLabelProductCodeWithCheckerDigit'] =
        balanceLabelProductCodeWithCheckerDigit;
    data['BalanceLabelValueOrQuantityType'] = balanceLabelValueOrQuantityType;
    data['RoundingType'] = roundingType;
    data['AllowDiscountOnOffer'] = allowDiscountOnOffer;
    data['AllowDiscountOnWholeSale'] = allowDiscountOnWholeSale;
    data['AllowManualDiscountOnAutomaticDiscount'] =
        allowManualDiscountOnAutomaticDiscount;
    data['UseDiscountLiquidFromSaleNegotiation'] =
        useDiscountLiquidFromSaleNegotiation;
    data['AcceptCheckCustomerNotKnow'] = acceptCheckCustomerNotKnow;
    data['UseFinalizationCheckLikePortion'] = useFinalizationCheckLikePortion;
    data['InternalCustomerCode'] = internalCustomerCode;
    data['ProductInternalCodeToDonation'] = productInternalCodeToDonation;
    data['AllowParcelling'] = allowParcelling;
    data['OpenCashDrawerOnlyForMoney'] = openCashDrawerOnlyForMoney;
    data['ShowValuesOnBleeding'] = showValuesOnBleeding;
    data['ShowOnlyCardValuesOnBleeding'] = showOnlyCardValuesOnBleeding;
    data['ShowPOSValuesOnBleeding'] = showPOSValuesOnBleeding;
    data['LimitValueToBleedByCashierBalanceValues'] =
        limitValueToBleedByCashierBalanceValues;
    data['BlockadeCashierOnLimitBleedingExceed'] =
        blockadeCashierOnLimitBleedingExceed;
    data['ConsiderBottomCashierValueOnBleeding'] =
        considerBottomCashierValueOnBleeding;
    data['AskSaleIsTravel'] = askSaleIsTravel;
    data['UseDeliveryControl'] = useDeliveryControl;
    data['UseDeliveryControlFastTable'] = useDeliveryControlFastTable;
    data['UseDeliveryControlAskFlagNumber'] = useDeliveryControlAskFlagNumber;
    data['RequestCustomerToDeliveryType'] = requestCustomerToDeliveryType;
    data['UseGiftControl'] = useGiftControl;
    data['SeparateDeliveryControlPayments'] = separateDeliveryControlPayments;
    data['ControlCashDrawerOpened'] = controlCashDrawerOpened;
    data['AllowCancelOnlyLastSale'] = allowCancelOnlyLastSale;
    data['AllowCancelAllItensOnCoupon'] = allowCancelAllItensOnCoupon;
    data['BlockadeSaleRequestTaxPayerInterState'] =
        blockadeSaleRequestTaxPayerInterState;
    data['BlockadeSaleRequestNotPrint'] = blockadeSaleRequestNotPrint;
    data['ObligatoryCovenantWhenCustomer'] = obligatoryCovenantWhenCustomer;
    data['PrintCouponModel'] = printCouponModel;
    data['PrintCouponTEFOrder'] = printCouponTEFOrder;
    data['UseMotiveCancellationType'] = useMotiveCancellationType;
    data['UseMotiveJustificationTypeOnBleeding'] =
        useMotiveJustificationTypeOnBleeding;
    data['UseMotiveJustificationTypeOnSaleDiscount'] =
        useMotiveJustificationTypeOnSaleDiscount;
    data['DiscountTypeAllowed'] = discountTypeAllowed;
    data['PrintProductCancelledAfterSale'] = printProductCancelledAfterSale;
    data['BalanceMask'] = balanceMask;
    data['SitefMsgVisor'] = sitefMsgVisor;
    data['SitefIPNumber'] = sitefIPNumber;
    data['SitefEnterpriseCode'] = sitefEnterpriseCode;
    data['SitefCustomerCode'] = sitefCustomerCode;
    data['SitefCliSitefAdditionalDataIni'] = sitefCliSitefAdditionalDataIni;
    data['DigitalWalletShowQRCodePayment'] = digitalWalletShowQRCodePayment;
    data['ConsumerCPFCNPJRequestType'] = consumerCPFCNPJRequestType;
    data['SaleRequestSellerRequestType'] = saleRequestSellerRequestType;
    data['SaleRequestOrigin'] = saleRequestOrigin;
    data['FinalizationPOSRequestNSUType'] = finalizationPOSRequestNSUType;
    data['PaymentFinalizationSelectMoneyAutomatically'] =
        paymentFinalizationSelectMoneyAutomatically;
    data['FillAutomaticallyCPFCNPJWithCustomerData'] =
        fillAutomaticallyCPFCNPJWithCustomerData;
    data['ParcelMaxPortionsNumber'] = parcelMaxPortionsNumber;
    data['ShowPortionsNumberWithGride'] = showPortionsNumberWithGride;
    data['CeltaBSUrlCCS'] = celtaBSUrlCCS;
    data['CeltaBSUrlBSF'] = celtaBSUrlBSF;
    data['CeltaBSCrossIdentity'] = celtaBSCrossIdentity;
    data['MercaFacilDiscountsTokenApi'] = mercaFacilDiscountsTokenApi;
    data['MercaFacilDiscountsIsEnabled'] = mercaFacilDiscountsIsEnabled;
    data['BonifiQUser'] = bonifiQUser;
    data['BonifiQPassword'] = bonifiQPassword;
    data['BonifiQIsEnabled'] = bonifiQIsEnabled;
    data['CresceVendasUser'] = cresceVendasUser;
    data['CresceVendasPassword'] = cresceVendasPassword;
    data['CresceVendasIsEnabled'] = cresceVendasIsEnabled;
    data['CupomMsgBottom'] = cupomMsgBottom;
    data['CupomMsgExchangeInformation'] = cupomMsgExchangeInformation;
    data['PdvAspectViwModelType'] = pdvAspectViwModelType;
    data['SaleMsgInitial'] = saleMsgInitial;
    data['UseCupomPrintSimplify'] = useCupomPrintSimplify;
    data['UseCupomPrintAllProductName'] = useCupomPrintAllProductName;
    data['PrintDiscountProductsOnCoupon'] = printDiscountProductsOnCoupon;
    data['AllowNFCeEmission'] = allowNFCeEmission;
    data['PathToGenerateXmlSATNFCe'] = pathToGenerateXmlSATNFCe;
    data['ProductSearchPluCodeWithDigit'] = productSearchPluCodeWithDigit;
    data['DisableSearchDotProductDigit'] = disableSearchDotProductDigit;
    data['DisableSearchPluForProductEan'] = disableSearchPluForProductEan;
    data['ShowStockValueOnProductConsult'] = showStockValueOnProductConsult;
    data['SaleProductMaxQtdItem'] = saleProductMaxQtdItem;
    data['SaleProductBalanceMaxQtdItem'] = saleProductBalanceMaxQtdItem;
    data['ImageMarketingSecondsForIdleTime'] = imageMarketingSecondsForIdleTime;
    data['ImageMarketingSecondsForShowEachImage'] =
        imageMarketingSecondsForShowEachImage;
    data['AllowMaxQtdItemExceedAuthorization'] =
        allowMaxQtdItemExceedAuthorization;
    data['UrlSATSharingTotalCouponGroup'] = urlSATSharingTotalCouponGroup;
    data['SATSharingBlockadeForTEF'] = sATSharingBlockadeForTEF;
    data['SATSharingBlockadeForCustomerIdentifier'] =
        sATSharingBlockadeForCustomerIdentifier;
    if (enterprise != null) {
      data['Enterprise'] = enterprise!.toJson();
    }
    data['RequestSalePriceTypeOnInitialSale'] =
        requestSalePriceTypeOnInitialSale;
    data['ShowWholeSalePriceOnProductConsult'] =
        showWholeSalePriceOnProductConsult;
    data['DaysToMaintainHistory'] = daysToMaintainHistory;
    data['BleedingPrintNumber'] = bleedingPrintNumber;
    data['PrintNumberForPOSVoucher'] = printNumberForPOSVoucher;
    data['PrintNumberForCovenantVoucher'] = printNumberForCovenantVoucher;
    data['PrintNumberForCreditDevolutionVoucher'] =
        printNumberForCreditDevolutionVoucher;
    data['PrintNumberForExchangeInformation'] =
        printNumberForExchangeInformation;
    data['PrintNumberForDeliveryVoucher'] = printNumberForDeliveryVoucher;
    data['ShowCustomerAddress'] = showCustomerAddress;
    data['ShowCustomerTelephone'] = showCustomerTelephone;
    data['ActivePromotionChampionMarks'] = activePromotionChampionMarks;
    data['TEFRequestOriginParceling'] = tEFRequestOriginParceling;
    data['UseControlCashierClose'] = useControlCashierClose;
    data['Use24HsCashierMovement'] = use24HsCashierMovement;
    data['UserAuthenticationModelType'] = userAuthenticationModelType;
    data['XavierCardIsEnabled'] = xavierCardIsEnabled;
    data['XavierCardUrl'] = xavierCardUrl;
    data['XavierCardEnterpriseCode'] = xavierCardEnterpriseCode;
    data['XavierCardUserCode'] = xavierCardUserCode;
    data['XavierCardUserPassword'] = xavierCardUserPassword;
    data['VidaMaisCardIsEnabled'] = vidaMaisCardIsEnabled;
    data['VidaMaisCardUserCode'] = vidaMaisCardUserCode;
    data['VidaMaisCardUserPassword'] = vidaMaisCardUserPassword;
    data['VidaMaisCardSellerCode'] = vidaMaisCardSellerCode;
    data['ParkingControlType'] = parkingControlType;
    data['ParkingControlIPAddress'] = parkingControlIPAddress;
    data['ParkingControlIPPort'] = parkingControlIPPort;
    return data;
  }
}
