import 'package:equatable/equatable.dart';

import 'entities.dart';

class EnterpriseConcentradorParametersEntity extends Equatable {
  final EnterpriseConcentradorEntity? enterprise;
  final bool? useBalanceOnPdv;
  final bool? balanceLabelProductCodeWithCheckerDigit;
  final bool? allowDiscountOnOffer;
  final bool? allowDiscountOnWholeSale;
  final bool? allowManualDiscountOnAutomaticDiscount;
  final bool? useDiscountLiquidFromSaleNegotiation;
  final bool? acceptCheckCustomerNotKnow;
  final bool? useFinalizationCheckLikePortion;
  final bool? allowParcelling;
  final bool? openCashDrawerOnlyForMoney;
  final bool? showValuesOnBleeding;
  final bool? showOnlyCardValuesOnBleeding;
  final bool? showPOSValuesOnBleeding;
  final bool? limitValueToBleedByCashierBalanceValues;
  final bool? blockadeCashierOnLimitBleedingExceed;
  final bool? considerBottomCashierValueOnBleeding;
  final bool? askSaleIsTravel;
  final bool? useDeliveryControl;
  final bool? useDeliveryControlFastTable;
  final bool? useDeliveryControlAskFlagNumber;
  final bool? requestCustomerToDeliveryType;
  final bool? useGiftControl;
  final bool? separateDeliveryControlPayments;
  final bool? controlCashDrawerOpened;
  final bool? allowCancelAllItensOnCoupon;
  final bool? blockadeSaleRequestTaxPayerInterState;
  final bool? blockadeSaleRequestNotPrint;
  final bool? obligatoryCovenantWhenCustomer;
  final bool? printProductCancelledAfterSale;
  final bool? paymentFinalizationSelectMoneyAutomatically;
  final bool? fillAutomaticallyCPFCNPJWithCustomerData;
  final bool? showPortionsNumberWithGride;
  final bool? mercaFacilDiscountsIsEnabled;
  final bool? bonifiQIsEnabled;
  final bool? cresceVendasIsEnabled;
  final bool? useCupomPrintSimplify;
  final bool? useCupomPrintAllProductName;
  final bool? printDiscountProductsOnCoupon;
  final bool? allowNFCeEmission;
  final bool? productSearchPluCodeWithDigit;
  final bool? disableSearchDotProductDigit;
  final bool? disableSearchPluForProductEan;
  final bool? showStockValueOnProductConsult;
  final bool? allowMaxQtdItemExceedAuthorization;
  final bool? sATSharingBlockadeForTEF;
  final bool? sATSharingBlockadeForCustomerIdentifier;
  final bool? requestSalePriceTypeOnInitialSale;
  final bool? showWholeSalePriceOnProductConsult;
  final bool? showCustomerAddress;
  final bool? showCustomerTelephone;
  final bool? activePromotionChampionMarks;
  final bool? tEFRequestOriginParceling;
  final bool? useControlCashierClose;
  final bool? use24HsCashierMovement;
  final bool? xavierCardIsEnabled;
  final bool? vidaMaisCardIsEnabled;
  final int? parametersId;
  final int? balanceLabelProductCodeSize;
  final int? balanceLabelValueOrQuantityType;
  final int? roundingType;
  final int? internalCustomerCode;
  final int? allowCancelOnlyLastSale;
  final int? printCouponModel;
  final int? printCouponTEFOrder;
  final int? useMotiveCancellationType;
  final int? useMotiveJustificationTypeOnBleeding;
  final int? useMotiveJustificationTypeOnSaleDiscount;
  final int? discountTypeAllowed;
  final int? digitalWalletShowQRCodePayment;
  final int? consumerCPFCNPJRequestType;
  final int? saleRequestSellerRequestType;
  final int? saleRequestOrigin;
  final int? finalizationPOSRequestNSUType;
  final int? parcelMaxPortionsNumber;
  final int? pdvAspectViwModelType;
  final int? saleProductMaxQtdItem;
  final int? urlSATSharingTotalCouponGroup;
  final int? daysToMaintainHistory;
  final int? bleedingPrintNumber;
  final int? printNumberForPOSVoucher;
  final int? printNumberForCovenantVoucher;
  final int? printNumberForCreditDevolutionVoucher;
  final int? printNumberForExchangeInformation;
  final int? printNumberForDeliveryVoucher;
  final int? userAuthenticationModelType;
  final int? parkingControlType;
  final int? parkingControlIPPort;
  final String? balanceMask;
  final String? celtaBSUrlCCS;
  final String? celtaBSUrlBSF;
  final String? celtaBSCrossIdentity;
  final String? saleMsgInitial;
  final dynamic productInternalCodeToDonation;
  final dynamic sitefMsgVisor;
  final dynamic sitefIPNumber;
  final dynamic sitefEnterpriseCode;
  final dynamic sitefCustomerCode;
  final dynamic sitefCliSitefAdditionalDataIni;
  final dynamic mercaFacilDiscountsTokenApi;
  final dynamic bonifiQUser;
  final dynamic bonifiQPassword;
  final dynamic cresceVendasUser;
  final dynamic cresceVendasPassword;
  final dynamic cupomMsgBottom;
  final dynamic cupomMsgExchangeInformation;
  final dynamic pathToGenerateXmlSATNFCe;
  final dynamic saleProductBalanceMaxQtdItem;
  final dynamic imageMarketingSecondsForIdleTime;
  final dynamic imageMarketingSecondsForShowEachImage;
  final dynamic xavierCardUrl;
  final dynamic xavierCardEnterpriseCode;
  final dynamic xavierCardUserCode;
  final dynamic xavierCardUserPassword;
  final dynamic vidaMaisCardUserCode;
  final dynamic vidaMaisCardUserPassword;
  final dynamic vidaMaisCardSellerCode;
  final dynamic parkingControlIPAddress;

  const EnterpriseConcentradorParametersEntity({
    required this.enterprise,
    required this.useBalanceOnPdv,
    required this.balanceLabelProductCodeWithCheckerDigit,
    required this.allowDiscountOnOffer,
    required this.allowDiscountOnWholeSale,
    required this.allowManualDiscountOnAutomaticDiscount,
    required this.useDiscountLiquidFromSaleNegotiation,
    required this.acceptCheckCustomerNotKnow,
    required this.useFinalizationCheckLikePortion,
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
    required this.allowCancelAllItensOnCoupon,
    required this.blockadeSaleRequestTaxPayerInterState,
    required this.blockadeSaleRequestNotPrint,
    required this.obligatoryCovenantWhenCustomer,
    required this.printProductCancelledAfterSale,
    required this.paymentFinalizationSelectMoneyAutomatically,
    required this.fillAutomaticallyCPFCNPJWithCustomerData,
    required this.showPortionsNumberWithGride,
    required this.mercaFacilDiscountsIsEnabled,
    required this.bonifiQIsEnabled,
    required this.cresceVendasIsEnabled,
    required this.useCupomPrintSimplify,
    required this.useCupomPrintAllProductName,
    required this.printDiscountProductsOnCoupon,
    required this.allowNFCeEmission,
    required this.productSearchPluCodeWithDigit,
    required this.disableSearchDotProductDigit,
    required this.disableSearchPluForProductEan,
    required this.showStockValueOnProductConsult,
    required this.allowMaxQtdItemExceedAuthorization,
    required this.sATSharingBlockadeForTEF,
    required this.sATSharingBlockadeForCustomerIdentifier,
    required this.requestSalePriceTypeOnInitialSale,
    required this.showWholeSalePriceOnProductConsult,
    required this.showCustomerAddress,
    required this.showCustomerTelephone,
    required this.activePromotionChampionMarks,
    required this.tEFRequestOriginParceling,
    required this.useControlCashierClose,
    required this.use24HsCashierMovement,
    required this.xavierCardIsEnabled,
    required this.vidaMaisCardIsEnabled,
    required this.parametersId,
    required this.balanceLabelProductCodeSize,
    required this.balanceLabelValueOrQuantityType,
    required this.roundingType,
    required this.internalCustomerCode,
    required this.allowCancelOnlyLastSale,
    required this.printCouponModel,
    required this.printCouponTEFOrder,
    required this.useMotiveCancellationType,
    required this.useMotiveJustificationTypeOnBleeding,
    required this.useMotiveJustificationTypeOnSaleDiscount,
    required this.discountTypeAllowed,
    required this.digitalWalletShowQRCodePayment,
    required this.consumerCPFCNPJRequestType,
    required this.saleRequestSellerRequestType,
    required this.saleRequestOrigin,
    required this.finalizationPOSRequestNSUType,
    required this.parcelMaxPortionsNumber,
    required this.pdvAspectViwModelType,
    required this.saleProductMaxQtdItem,
    required this.urlSATSharingTotalCouponGroup,
    required this.daysToMaintainHistory,
    required this.bleedingPrintNumber,
    required this.printNumberForPOSVoucher,
    required this.printNumberForCovenantVoucher,
    required this.printNumberForCreditDevolutionVoucher,
    required this.printNumberForExchangeInformation,
    required this.printNumberForDeliveryVoucher,
    required this.userAuthenticationModelType,
    required this.parkingControlType,
    required this.parkingControlIPPort,
    required this.balanceMask,
    required this.celtaBSUrlCCS,
    required this.celtaBSUrlBSF,
    required this.celtaBSCrossIdentity,
    required this.saleMsgInitial,
    required this.productInternalCodeToDonation,
    required this.sitefMsgVisor,
    required this.sitefIPNumber,
    required this.sitefEnterpriseCode,
    required this.sitefCustomerCode,
    required this.sitefCliSitefAdditionalDataIni,
    required this.mercaFacilDiscountsTokenApi,
    required this.bonifiQUser,
    required this.bonifiQPassword,
    required this.cresceVendasUser,
    required this.cresceVendasPassword,
    required this.cupomMsgBottom,
    required this.cupomMsgExchangeInformation,
    required this.pathToGenerateXmlSATNFCe,
    required this.saleProductBalanceMaxQtdItem,
    required this.imageMarketingSecondsForIdleTime,
    required this.imageMarketingSecondsForShowEachImage,
    required this.xavierCardUrl,
    required this.xavierCardEnterpriseCode,
    required this.xavierCardUserCode,
    required this.xavierCardUserPassword,
    required this.vidaMaisCardUserCode,
    required this.vidaMaisCardUserPassword,
    required this.vidaMaisCardSellerCode,
    required this.parkingControlIPAddress,
  });

  @override
  List<Object?> get props => [
        enterprise,
        useBalanceOnPdv,
        balanceLabelProductCodeWithCheckerDigit,
        allowDiscountOnOffer,
        allowDiscountOnWholeSale,
        allowManualDiscountOnAutomaticDiscount,
        useDiscountLiquidFromSaleNegotiation,
        acceptCheckCustomerNotKnow,
        useFinalizationCheckLikePortion,
        allowParcelling,
        openCashDrawerOnlyForMoney,
        showValuesOnBleeding,
        showOnlyCardValuesOnBleeding,
        showPOSValuesOnBleeding,
        limitValueToBleedByCashierBalanceValues,
        blockadeCashierOnLimitBleedingExceed,
        considerBottomCashierValueOnBleeding,
        askSaleIsTravel,
        useDeliveryControl,
        useDeliveryControlFastTable,
        useDeliveryControlAskFlagNumber,
        requestCustomerToDeliveryType,
        useGiftControl,
        separateDeliveryControlPayments,
        controlCashDrawerOpened,
        allowCancelAllItensOnCoupon,
        blockadeSaleRequestTaxPayerInterState,
        blockadeSaleRequestNotPrint,
        obligatoryCovenantWhenCustomer,
        printProductCancelledAfterSale,
        paymentFinalizationSelectMoneyAutomatically,
        fillAutomaticallyCPFCNPJWithCustomerData,
        showPortionsNumberWithGride,
        mercaFacilDiscountsIsEnabled,
        bonifiQIsEnabled,
        cresceVendasIsEnabled,
        useCupomPrintSimplify,
        useCupomPrintAllProductName,
        printDiscountProductsOnCoupon,
        allowNFCeEmission,
        productSearchPluCodeWithDigit,
        disableSearchDotProductDigit,
        disableSearchPluForProductEan,
        showStockValueOnProductConsult,
        allowMaxQtdItemExceedAuthorization,
        sATSharingBlockadeForTEF,
        sATSharingBlockadeForCustomerIdentifier,
        requestSalePriceTypeOnInitialSale,
        showWholeSalePriceOnProductConsult,
        showCustomerAddress,
        showCustomerTelephone,
        activePromotionChampionMarks,
        tEFRequestOriginParceling,
        useControlCashierClose,
        use24HsCashierMovement,
        xavierCardIsEnabled,
        vidaMaisCardIsEnabled,
        parametersId,
        balanceLabelProductCodeSize,
        balanceLabelValueOrQuantityType,
        roundingType,
        internalCustomerCode,
        allowCancelOnlyLastSale,
        printCouponModel,
        printCouponTEFOrder,
        useMotiveCancellationType,
        useMotiveJustificationTypeOnBleeding,
        useMotiveJustificationTypeOnSaleDiscount,
        discountTypeAllowed,
        digitalWalletShowQRCodePayment,
        consumerCPFCNPJRequestType,
        saleRequestSellerRequestType,
        saleRequestOrigin,
        finalizationPOSRequestNSUType,
        parcelMaxPortionsNumber,
        pdvAspectViwModelType,
        saleProductMaxQtdItem,
        urlSATSharingTotalCouponGroup,
        daysToMaintainHistory,
        bleedingPrintNumber,
        printNumberForPOSVoucher,
        printNumberForCovenantVoucher,
        printNumberForCreditDevolutionVoucher,
        printNumberForExchangeInformation,
        printNumberForDeliveryVoucher,
        userAuthenticationModelType,
        parkingControlType,
        parkingControlIPPort,
        balanceMask,
        celtaBSUrlCCS,
        celtaBSUrlBSF,
        celtaBSCrossIdentity,
        saleMsgInitial,
        productInternalCodeToDonation,
        sitefMsgVisor,
        sitefIPNumber,
        sitefEnterpriseCode,
        sitefCustomerCode,
        sitefCliSitefAdditionalDataIni,
        mercaFacilDiscountsTokenApi,
        bonifiQUser,
        bonifiQPassword,
        cresceVendasUser,
        cresceVendasPassword,
        cupomMsgBottom,
        cupomMsgExchangeInformation,
        pathToGenerateXmlSATNFCe,
        saleProductBalanceMaxQtdItem,
        imageMarketingSecondsForIdleTime,
        imageMarketingSecondsForShowEachImage,
        xavierCardUrl,
        xavierCardEnterpriseCode,
        xavierCardUserCode,
        xavierCardUserPassword,
        vidaMaisCardUserCode,
        vidaMaisCardUserPassword,
        vidaMaisCardSellerCode,
        parkingControlIPAddress,
      ];
}
