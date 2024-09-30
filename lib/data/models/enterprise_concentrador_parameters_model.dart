import '../../domain/entities/entities.dart';
import 'models.dart';

class EnterpriseConcentradorParametersModel {
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
  EnterpriseConcentradorModel? enterprise;
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

  EnterpriseConcentradorParametersModel({
    required this.parametersId,
    required this.useBalanceOnPdv,
    required this.balanceLabelProductCodeSize,
    required this.balanceLabelProductCodeWithCheckerDigit,
    required this.balanceLabelValueOrQuantityType,
    required this.roundingType,
    required this.allowDiscountOnOffer,
    required this.allowDiscountOnWholeSale,
    required this.allowManualDiscountOnAutomaticDiscount,
    required this.useDiscountLiquidFromSaleNegotiation,
    required this.acceptCheckCustomerNotKnow,
    required this.useFinalizationCheckLikePortion,
    required this.internalCustomerCode,
    required this.productInternalCodeToDonation,
    required this.allowParcelling,
    required this.openCashDrawerOnlyForMoney,
    required this.showValuesOnBleeding,
    required this.showOnlyCardValuesOnBleeding,
    required this.showPOSValuesOnBleeding,
    required this.limitValueToBleedByCashierBalanceValues,
    required this.blockadeCashierOnLimitBleedingExceed,
    required this.considerBottomCashierValueOnBleeding,
    required this.askSaleIsTravel,
    required this.useDeliveryControl,
    required this.useDeliveryControlFastTable,
    required this.useDeliveryControlAskFlagNumber,
    required this.requestCustomerToDeliveryType,
    required this.useGiftControl,
    required this.separateDeliveryControlPayments,
    required this.controlCashDrawerOpened,
    required this.allowCancelOnlyLastSale,
    required this.allowCancelAllItensOnCoupon,
    required this.blockadeSaleRequestTaxPayerInterState,
    required this.blockadeSaleRequestNotPrint,
    required this.obligatoryCovenantWhenCustomer,
    required this.printCouponModel,
    required this.printCouponTEFOrder,
    required this.useMotiveCancellationType,
    required this.useMotiveJustificationTypeOnBleeding,
    required this.useMotiveJustificationTypeOnSaleDiscount,
    required this.discountTypeAllowed,
    required this.printProductCancelledAfterSale,
    required this.balanceMask,
    required this.sitefMsgVisor,
    required this.sitefIPNumber,
    required this.sitefEnterpriseCode,
    required this.sitefCustomerCode,
    required this.sitefCliSitefAdditionalDataIni,
    required this.digitalWalletShowQRCodePayment,
    required this.consumerCPFCNPJRequestType,
    required this.saleRequestSellerRequestType,
    required this.saleRequestOrigin,
    required this.finalizationPOSRequestNSUType,
    required this.paymentFinalizationSelectMoneyAutomatically,
    required this.fillAutomaticallyCPFCNPJWithCustomerData,
    required this.parcelMaxPortionsNumber,
    required this.showPortionsNumberWithGride,
    required this.celtaBSUrlCCS,
    required this.celtaBSUrlBSF,
    required this.celtaBSCrossIdentity,
    required this.mercaFacilDiscountsTokenApi,
    required this.mercaFacilDiscountsIsEnabled,
    required this.bonifiQUser,
    required this.bonifiQPassword,
    required this.bonifiQIsEnabled,
    required this.cresceVendasUser,
    required this.cresceVendasPassword,
    required this.cresceVendasIsEnabled,
    required this.cupomMsgBottom,
    required this.cupomMsgExchangeInformation,
    required this.pdvAspectViwModelType,
    required this.saleMsgInitial,
    required this.useCupomPrintSimplify,
    required this.useCupomPrintAllProductName,
    required this.printDiscountProductsOnCoupon,
    required this.allowNFCeEmission,
    required this.pathToGenerateXmlSATNFCe,
    required this.productSearchPluCodeWithDigit,
    required this.disableSearchDotProductDigit,
    required this.disableSearchPluForProductEan,
    required this.showStockValueOnProductConsult,
    required this.saleProductMaxQtdItem,
    required this.saleProductBalanceMaxQtdItem,
    required this.imageMarketingSecondsForIdleTime,
    required this.imageMarketingSecondsForShowEachImage,
    required this.allowMaxQtdItemExceedAuthorization,
    required this.urlSATSharingTotalCouponGroup,
    required this.sATSharingBlockadeForTEF,
    required this.sATSharingBlockadeForCustomerIdentifier,
    required this.enterprise,
    required this.requestSalePriceTypeOnInitialSale,
    required this.showWholeSalePriceOnProductConsult,
    required this.daysToMaintainHistory,
    required this.bleedingPrintNumber,
    required this.printNumberForPOSVoucher,
    required this.printNumberForCovenantVoucher,
    required this.printNumberForCreditDevolutionVoucher,
    required this.printNumberForExchangeInformation,
    required this.printNumberForDeliveryVoucher,
    required this.showCustomerAddress,
    required this.showCustomerTelephone,
    required this.activePromotionChampionMarks,
    required this.tEFRequestOriginParceling,
    required this.useControlCashierClose,
    required this.use24HsCashierMovement,
    required this.userAuthenticationModelType,
    required this.xavierCardIsEnabled,
    required this.xavierCardUrl,
    required this.xavierCardEnterpriseCode,
    required this.xavierCardUserCode,
    required this.xavierCardUserPassword,
    required this.vidaMaisCardIsEnabled,
    required this.vidaMaisCardUserCode,
    required this.vidaMaisCardUserPassword,
    required this.vidaMaisCardSellerCode,
    required this.parkingControlType,
    required this.parkingControlIPAddress,
    required this.parkingControlIPPort,
  });

  EnterpriseConcentradorParametersModel.fromJson(Map<String, dynamic> json) {
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
        ? EnterpriseConcentradorModel.fromJson(json['Enterprise'])
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

  factory EnterpriseConcentradorParametersModel.fromEntity(
          EnterpriseConcentradorParametersEntity entity) =>
      EnterpriseConcentradorParametersModel(
        parametersId: entity.parametersId,
        useBalanceOnPdv: entity.useBalanceOnPdv,
        balanceLabelProductCodeSize: entity.balanceLabelProductCodeSize,
        balanceLabelProductCodeWithCheckerDigit:
            entity.balanceLabelProductCodeWithCheckerDigit,
        balanceLabelValueOrQuantityType: entity.balanceLabelValueOrQuantityType,
        roundingType: entity.roundingType,
        allowDiscountOnOffer: entity.allowDiscountOnOffer,
        allowDiscountOnWholeSale: entity.allowDiscountOnWholeSale,
        allowManualDiscountOnAutomaticDiscount:
            entity.allowManualDiscountOnAutomaticDiscount,
        useDiscountLiquidFromSaleNegotiation:
            entity.useDiscountLiquidFromSaleNegotiation,
        acceptCheckCustomerNotKnow: entity.acceptCheckCustomerNotKnow,
        useFinalizationCheckLikePortion: entity.useFinalizationCheckLikePortion,
        internalCustomerCode: entity.internalCustomerCode,
        productInternalCodeToDonation: entity.productInternalCodeToDonation,
        allowParcelling: entity.allowParcelling,
        openCashDrawerOnlyForMoney: entity.openCashDrawerOnlyForMoney,
        showValuesOnBleeding: entity.showValuesOnBleeding,
        showOnlyCardValuesOnBleeding: entity.showOnlyCardValuesOnBleeding,
        showPOSValuesOnBleeding: entity.showPOSValuesOnBleeding,
        limitValueToBleedByCashierBalanceValues:
            entity.limitValueToBleedByCashierBalanceValues,
        blockadeCashierOnLimitBleedingExceed:
            entity.blockadeCashierOnLimitBleedingExceed,
        considerBottomCashierValueOnBleeding:
            entity.considerBottomCashierValueOnBleeding,
        askSaleIsTravel: entity.askSaleIsTravel,
        useDeliveryControl: entity.useDeliveryControl,
        useDeliveryControlFastTable: entity.useDeliveryControlFastTable,
        useDeliveryControlAskFlagNumber: entity.useDeliveryControlAskFlagNumber,
        requestCustomerToDeliveryType: entity.requestCustomerToDeliveryType,
        useGiftControl: entity.useGiftControl,
        separateDeliveryControlPayments: entity.separateDeliveryControlPayments,
        controlCashDrawerOpened: entity.controlCashDrawerOpened,
        allowCancelOnlyLastSale: entity.allowCancelOnlyLastSale,
        allowCancelAllItensOnCoupon: entity.allowCancelAllItensOnCoupon,
        blockadeSaleRequestTaxPayerInterState:
            entity.blockadeSaleRequestTaxPayerInterState,
        blockadeSaleRequestNotPrint: entity.blockadeSaleRequestNotPrint,
        obligatoryCovenantWhenCustomer: entity.obligatoryCovenantWhenCustomer,
        printCouponModel: entity.printCouponModel,
        printCouponTEFOrder: entity.printCouponTEFOrder,
        useMotiveCancellationType: entity.useMotiveCancellationType,
        useMotiveJustificationTypeOnBleeding:
            entity.useMotiveJustificationTypeOnBleeding,
        useMotiveJustificationTypeOnSaleDiscount:
            entity.useMotiveJustificationTypeOnSaleDiscount,
        discountTypeAllowed: entity.discountTypeAllowed,
        printProductCancelledAfterSale: entity.printProductCancelledAfterSale,
        balanceMask: entity.balanceMask,
        sitefMsgVisor: entity.sitefMsgVisor,
        sitefIPNumber: entity.sitefIPNumber,
        sitefEnterpriseCode: entity.sitefEnterpriseCode,
        sitefCustomerCode: entity.sitefCustomerCode,
        sitefCliSitefAdditionalDataIni: entity.sitefCliSitefAdditionalDataIni,
        digitalWalletShowQRCodePayment: entity.digitalWalletShowQRCodePayment,
        consumerCPFCNPJRequestType: entity.consumerCPFCNPJRequestType,
        saleRequestSellerRequestType: entity.saleRequestSellerRequestType,
        saleRequestOrigin: entity.saleRequestOrigin,
        finalizationPOSRequestNSUType: entity.finalizationPOSRequestNSUType,
        paymentFinalizationSelectMoneyAutomatically:
            entity.paymentFinalizationSelectMoneyAutomatically,
        fillAutomaticallyCPFCNPJWithCustomerData:
            entity.fillAutomaticallyCPFCNPJWithCustomerData,
        parcelMaxPortionsNumber: entity.parcelMaxPortionsNumber,
        showPortionsNumberWithGride: entity.showPortionsNumberWithGride,
        celtaBSUrlCCS: entity.celtaBSUrlCCS,
        celtaBSUrlBSF: entity.celtaBSUrlBSF,
        celtaBSCrossIdentity: entity.celtaBSCrossIdentity,
        mercaFacilDiscountsTokenApi: entity.mercaFacilDiscountsTokenApi,
        mercaFacilDiscountsIsEnabled: entity.mercaFacilDiscountsIsEnabled,
        bonifiQUser: entity.bonifiQUser,
        bonifiQPassword: entity.bonifiQPassword,
        bonifiQIsEnabled: entity.bonifiQIsEnabled,
        cresceVendasUser: entity.cresceVendasUser,
        cresceVendasPassword: entity.cresceVendasPassword,
        cresceVendasIsEnabled: entity.cresceVendasIsEnabled,
        cupomMsgBottom: entity.cupomMsgBottom,
        cupomMsgExchangeInformation: entity.cupomMsgExchangeInformation,
        pdvAspectViwModelType: entity.pdvAspectViwModelType,
        saleMsgInitial: entity.saleMsgInitial,
        useCupomPrintSimplify: entity.useCupomPrintSimplify,
        useCupomPrintAllProductName: entity.useCupomPrintAllProductName,
        printDiscountProductsOnCoupon: entity.printDiscountProductsOnCoupon,
        allowNFCeEmission: entity.allowNFCeEmission,
        pathToGenerateXmlSATNFCe: entity.pathToGenerateXmlSATNFCe,
        productSearchPluCodeWithDigit: entity.productSearchPluCodeWithDigit,
        disableSearchDotProductDigit: entity.disableSearchDotProductDigit,
        disableSearchPluForProductEan: entity.disableSearchPluForProductEan,
        showStockValueOnProductConsult: entity.showStockValueOnProductConsult,
        saleProductMaxQtdItem: entity.saleProductMaxQtdItem,
        saleProductBalanceMaxQtdItem: entity.saleProductBalanceMaxQtdItem,
        imageMarketingSecondsForIdleTime:
            entity.imageMarketingSecondsForIdleTime,
        imageMarketingSecondsForShowEachImage:
            entity.imageMarketingSecondsForShowEachImage,
        allowMaxQtdItemExceedAuthorization:
            entity.allowMaxQtdItemExceedAuthorization,
        urlSATSharingTotalCouponGroup: entity.urlSATSharingTotalCouponGroup,
        sATSharingBlockadeForTEF: entity.sATSharingBlockadeForTEF,
        sATSharingBlockadeForCustomerIdentifier:
            entity.sATSharingBlockadeForCustomerIdentifier,
        enterprise: entity.enterprise != null
            ? EnterpriseConcentradorModel.fromEntity(entity.enterprise!)
            : null,
        requestSalePriceTypeOnInitialSale:
            entity.requestSalePriceTypeOnInitialSale,
        showWholeSalePriceOnProductConsult:
            entity.showWholeSalePriceOnProductConsult,
        daysToMaintainHistory: entity.daysToMaintainHistory,
        bleedingPrintNumber: entity.bleedingPrintNumber,
        printNumberForPOSVoucher: entity.printNumberForPOSVoucher,
        printNumberForCovenantVoucher: entity.printNumberForCovenantVoucher,
        printNumberForCreditDevolutionVoucher:
            entity.printNumberForCreditDevolutionVoucher,
        printNumberForExchangeInformation:
            entity.printNumberForExchangeInformation,
        printNumberForDeliveryVoucher: entity.printNumberForDeliveryVoucher,
        showCustomerAddress: entity.showCustomerAddress,
        showCustomerTelephone: entity.showCustomerTelephone,
        activePromotionChampionMarks: entity.activePromotionChampionMarks,
        tEFRequestOriginParceling: entity.tEFRequestOriginParceling,
        useControlCashierClose: entity.useControlCashierClose,
        use24HsCashierMovement: entity.use24HsCashierMovement,
        userAuthenticationModelType: entity.userAuthenticationModelType,
        xavierCardIsEnabled: entity.xavierCardIsEnabled,
        xavierCardUrl: entity.xavierCardUrl,
        xavierCardEnterpriseCode: entity.xavierCardEnterpriseCode,
        xavierCardUserCode: entity.xavierCardUserCode,
        xavierCardUserPassword: entity.xavierCardUserPassword,
        vidaMaisCardIsEnabled: entity.vidaMaisCardIsEnabled,
        vidaMaisCardUserCode: entity.vidaMaisCardUserCode,
        vidaMaisCardUserPassword: entity.vidaMaisCardUserPassword,
        vidaMaisCardSellerCode: entity.vidaMaisCardSellerCode,
        parkingControlType: entity.parkingControlType,
        parkingControlIPAddress: entity.parkingControlIPAddress,
        parkingControlIPPort: entity.parkingControlIPPort,
      );

  EnterpriseConcentradorParametersEntity toEntity() =>
      EnterpriseConcentradorParametersEntity(
        parametersId: parametersId,
        useBalanceOnPdv: useBalanceOnPdv,
        balanceLabelProductCodeSize: balanceLabelProductCodeSize,
        balanceLabelProductCodeWithCheckerDigit:
            balanceLabelProductCodeWithCheckerDigit,
        balanceLabelValueOrQuantityType: balanceLabelValueOrQuantityType,
        roundingType: roundingType,
        allowDiscountOnOffer: allowDiscountOnOffer,
        allowDiscountOnWholeSale: allowDiscountOnWholeSale,
        allowManualDiscountOnAutomaticDiscount:
            allowManualDiscountOnAutomaticDiscount,
        useDiscountLiquidFromSaleNegotiation:
            useDiscountLiquidFromSaleNegotiation,
        acceptCheckCustomerNotKnow: acceptCheckCustomerNotKnow,
        useFinalizationCheckLikePortion: useFinalizationCheckLikePortion,
        internalCustomerCode: internalCustomerCode,
        productInternalCodeToDonation: productInternalCodeToDonation,
        allowParcelling: allowParcelling,
        openCashDrawerOnlyForMoney: openCashDrawerOnlyForMoney,
        showValuesOnBleeding: showValuesOnBleeding,
        showOnlyCardValuesOnBleeding: showOnlyCardValuesOnBleeding,
        showPOSValuesOnBleeding: showPOSValuesOnBleeding,
        limitValueToBleedByCashierBalanceValues:
            limitValueToBleedByCashierBalanceValues,
        blockadeCashierOnLimitBleedingExceed:
            blockadeCashierOnLimitBleedingExceed,
        considerBottomCashierValueOnBleeding:
            considerBottomCashierValueOnBleeding,
        askSaleIsTravel: askSaleIsTravel,
        useDeliveryControl: useDeliveryControl,
        useDeliveryControlFastTable: useDeliveryControlFastTable,
        useDeliveryControlAskFlagNumber: useDeliveryControlAskFlagNumber,
        requestCustomerToDeliveryType: requestCustomerToDeliveryType,
        useGiftControl: useGiftControl,
        separateDeliveryControlPayments: separateDeliveryControlPayments,
        controlCashDrawerOpened: controlCashDrawerOpened,
        allowCancelOnlyLastSale: allowCancelOnlyLastSale,
        allowCancelAllItensOnCoupon: allowCancelAllItensOnCoupon,
        blockadeSaleRequestTaxPayerInterState:
            blockadeSaleRequestTaxPayerInterState,
        blockadeSaleRequestNotPrint: blockadeSaleRequestNotPrint,
        obligatoryCovenantWhenCustomer: obligatoryCovenantWhenCustomer,
        printCouponModel: printCouponModel,
        printCouponTEFOrder: printCouponTEFOrder,
        useMotiveCancellationType: useMotiveCancellationType,
        useMotiveJustificationTypeOnBleeding:
            useMotiveJustificationTypeOnBleeding,
        useMotiveJustificationTypeOnSaleDiscount:
            useMotiveJustificationTypeOnSaleDiscount,
        discountTypeAllowed: discountTypeAllowed,
        printProductCancelledAfterSale: printProductCancelledAfterSale,
        balanceMask: balanceMask,
        sitefMsgVisor: sitefMsgVisor,
        sitefIPNumber: sitefIPNumber,
        sitefEnterpriseCode: sitefEnterpriseCode,
        sitefCustomerCode: sitefCustomerCode,
        sitefCliSitefAdditionalDataIni: sitefCliSitefAdditionalDataIni,
        digitalWalletShowQRCodePayment: digitalWalletShowQRCodePayment,
        consumerCPFCNPJRequestType: consumerCPFCNPJRequestType,
        saleRequestSellerRequestType: saleRequestSellerRequestType,
        saleRequestOrigin: saleRequestOrigin,
        finalizationPOSRequestNSUType: finalizationPOSRequestNSUType,
        paymentFinalizationSelectMoneyAutomatically:
            paymentFinalizationSelectMoneyAutomatically,
        fillAutomaticallyCPFCNPJWithCustomerData:
            fillAutomaticallyCPFCNPJWithCustomerData,
        parcelMaxPortionsNumber: parcelMaxPortionsNumber,
        showPortionsNumberWithGride: showPortionsNumberWithGride,
        celtaBSUrlCCS: celtaBSUrlCCS,
        celtaBSUrlBSF: celtaBSUrlBSF,
        celtaBSCrossIdentity: celtaBSCrossIdentity,
        mercaFacilDiscountsTokenApi: mercaFacilDiscountsTokenApi,
        mercaFacilDiscountsIsEnabled: mercaFacilDiscountsIsEnabled,
        bonifiQUser: bonifiQUser,
        bonifiQPassword: bonifiQPassword,
        bonifiQIsEnabled: bonifiQIsEnabled,
        cresceVendasUser: cresceVendasUser,
        cresceVendasPassword: cresceVendasPassword,
        cresceVendasIsEnabled: cresceVendasIsEnabled,
        cupomMsgBottom: cupomMsgBottom,
        cupomMsgExchangeInformation: cupomMsgExchangeInformation,
        pdvAspectViwModelType: pdvAspectViwModelType,
        saleMsgInitial: saleMsgInitial,
        useCupomPrintSimplify: useCupomPrintSimplify,
        useCupomPrintAllProductName: useCupomPrintAllProductName,
        printDiscountProductsOnCoupon: printDiscountProductsOnCoupon,
        allowNFCeEmission: allowNFCeEmission,
        pathToGenerateXmlSATNFCe: pathToGenerateXmlSATNFCe,
        productSearchPluCodeWithDigit: productSearchPluCodeWithDigit,
        disableSearchDotProductDigit: disableSearchDotProductDigit,
        disableSearchPluForProductEan: disableSearchPluForProductEan,
        showStockValueOnProductConsult: showStockValueOnProductConsult,
        saleProductMaxQtdItem: saleProductMaxQtdItem,
        saleProductBalanceMaxQtdItem: saleProductBalanceMaxQtdItem,
        imageMarketingSecondsForIdleTime: imageMarketingSecondsForIdleTime,
        imageMarketingSecondsForShowEachImage:
            imageMarketingSecondsForShowEachImage,
        allowMaxQtdItemExceedAuthorization: allowMaxQtdItemExceedAuthorization,
        urlSATSharingTotalCouponGroup: urlSATSharingTotalCouponGroup,
        sATSharingBlockadeForTEF: sATSharingBlockadeForTEF,
        sATSharingBlockadeForCustomerIdentifier:
            sATSharingBlockadeForCustomerIdentifier,
        enterprise: enterprise?.toEntity(),
        requestSalePriceTypeOnInitialSale: requestSalePriceTypeOnInitialSale,
        showWholeSalePriceOnProductConsult: showWholeSalePriceOnProductConsult,
        daysToMaintainHistory: daysToMaintainHistory,
        bleedingPrintNumber: bleedingPrintNumber,
        printNumberForPOSVoucher: printNumberForPOSVoucher,
        printNumberForCovenantVoucher: printNumberForCovenantVoucher,
        printNumberForCreditDevolutionVoucher:
            printNumberForCreditDevolutionVoucher,
        printNumberForExchangeInformation: printNumberForExchangeInformation,
        printNumberForDeliveryVoucher: printNumberForDeliveryVoucher,
        showCustomerAddress: showCustomerAddress,
        showCustomerTelephone: showCustomerTelephone,
        activePromotionChampionMarks: activePromotionChampionMarks,
        tEFRequestOriginParceling: tEFRequestOriginParceling,
        useControlCashierClose: useControlCashierClose,
        use24HsCashierMovement: use24HsCashierMovement,
        userAuthenticationModelType: userAuthenticationModelType,
        xavierCardIsEnabled: xavierCardIsEnabled,
        xavierCardUrl: xavierCardUrl,
        xavierCardEnterpriseCode: xavierCardEnterpriseCode,
        xavierCardUserCode: xavierCardUserCode,
        xavierCardUserPassword: xavierCardUserPassword,
        vidaMaisCardIsEnabled: vidaMaisCardIsEnabled,
        vidaMaisCardUserCode: vidaMaisCardUserCode,
        vidaMaisCardUserPassword: vidaMaisCardUserPassword,
        vidaMaisCardSellerCode: vidaMaisCardSellerCode,
        parkingControlType: parkingControlType,
        parkingControlIPAddress: parkingControlIPAddress,
        parkingControlIPPort: parkingControlIPPort,
      );
}
