import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteConcInsertSaleMovement implements ConcInsertSaleMovement {
  final HttpClient httpAdapter;

  RemoteConcInsertSaleMovement({required this.httpAdapter});

  @override
  Future<int> insert({
    required int pdvId,
    required String pdvNumber,
    required int? covenantCode,
    required int? customerCode,
    required String? cpfCnpj,
    required int? incrementType,
    required double? incrementValue,
    required double totalLiquid,
    required List<SaleMovementConcentratorFinalizationEntity> finalizations,
    required List<SaleMovementProductConcentratorEntity> products,
    required String? xmlToGenerateFiscal,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = "${EnterpriseBuilder.entity!.concentradorUrl}/api/Insert";

      final saleMovement = _createSaleMovementEntity(
        pdvId: pdvId,
        pdvNumber: pdvNumber,
        covenantCode: covenantCode,
        customerCode: customerCode,
        cpfCnpj: cpfCnpj,
        incrementType: incrementType,
        incrementValue: incrementValue,
        totalLiquid: totalLiquid,
        finalizations: finalizations,
        products: products,
        xml: xmlToGenerateFiscal,
      );

      final response = await httpAdapter.request(
        url: url,
        method: "post",
        headers: headers,
        body: SaleMovementConcentratorModel.fromEntity(saleMovement).toJson(),
      );

      if (response == null) {
        throw Error();
      }

      return response;
    } catch (error) {
      rethrow;
    }
  }

  SaleMovementConcentratorEntity _createSaleMovementEntity({
    required String? xml,
    required int pdvId,
    required String pdvNumber,
    required int? covenantCode,
    required int? customerCode,
    required String? cpfCnpj,
    required int? incrementType,
    required double? incrementValue,
    required double totalLiquid,
    required List<SaleMovementConcentratorFinalizationEntity> finalizations,
    required List<SaleMovementProductConcentratorEntity> products,
  }) {
    final enterprise = EnterpriseBuilder.entity;
    return SaleMovementConcentratorEntity(
      XmlSatNfce: xml,
      SaleFiscalTypeString: null,
      SaleMovementId: null,
      PdvId: pdvId,
      PdvNumber: pdvNumber,
      SaleFiscalType:
          xml == null ? SaleFiscalType.nfceEmulador.id : SaleFiscalType.nfce.id,
      CovenantCode: covenantCode,
      CustomerCode: customerCode,
      CpfCnpj: cpfCnpj,
      DateHourOfCreation: DateTime.now().toIso8601String(),
      DateHourOfDelivery: DateTime.now().toIso8601String(),
      DateOfCreation: DateTime.now().toIso8601String(),
      EnterpriseCode: enterprise
          ?.enterpriseConcentradorParametersEntity?.enterprise?.enterpriseCode,
      EnterpriseId: enterprise?.enterpriseId,
      IncrementType: incrementType,
      IncrementValue: incrementValue,
      RoundingType: 2,
      SalePricePraticed: 0,
      TotalLiquid: totalLiquid,
      Finalizations: _getFinalizations(
        finalizations: finalizations,
        totalLiquid: totalLiquid,
      ),
      Products: _getProducts(products: products),
      SaleRequestPersonalizedCode: null,
      SellerCode: /* seller != null ? seller.SellersId : (int?)null */ null,
      SellerName: /* seller != null ? seller.Name : null */ null,
      PersonalizedCode: /* saleMovementPersonalizedCode */ null,
      MotiveJustificationName: null,
      MotiveJustificationId: null,
      CashierMovementId: null,
      CustomerAdditionalCode: null,
      CRMCpfCnpj: null,
      CRMDiscountTransactionId: null,
      CRMDiscountType: null,
      CRMDiscountValue: null,
      DeliveryControl: null,
      DiscountFinalizationValue: null,
      DiscountType: null,
      DiscountValue: null,
      EletronicAccessKey: null,
      FidelityControlsPoints: null,
      IsCancelled: false,
      IsDelivery: false,
      IsForTravel: false,
      IsToDelivery: 0,
      MotiveJustificationSaleDiscountId: null,
      MotiveJustificationSaleDiscountName: null,
      UserIdOfCancellation: null,
      UserIdOfDiscount: null,
      XmlSatNfceCancel: null,
      WasPrinted: false,
      CouponFiscalNumber: null,
    );
  }
}

List<SaleMovementConcentratorFinalizationEntity> _getFinalizations({
  required List<SaleMovementConcentratorFinalizationEntity> finalizations,
  required double totalLiquid,
}) =>
    finalizations.isEmpty
        ? [
            SaleMovementConcentratorFinalizationEntity(
              FinalizationId: FinalizationIdentification.money.finalizationId,
              PortionQuantity: 1,
              Value: totalLiquid,
              ValueLiquid: totalLiquid,
              SaleMovementFinalizationId: null,
              PayBackValue: null,
              AuthorizationCode: null,
              AuthorizationType: null,
              FinalizationPdvId: null,
              TEFNSUSitef: null,
              TEFNSUHost: null,
              TEFAuthorizationCode: null,
              TEFBinCode: null,
              TEFCardLastNumbers: null,
              TEFNetWorkCode: null,
              TEFFlagCode: null,
              TEFFlagDescription: null,
              TEFModalityPaymentCode: null,
              TEFModalityDescription: null,
              TEFPlanCardCode: null,
            )
          ]
        : finalizations;

List<SaleMovementProductConcentratorEntity> _getProducts({
  required List<SaleMovementProductConcentratorEntity> products,
}) {
  return products.map((e) {
    int position = 1;

    return SaleMovementProductConcentratorEntity(
      BlockadeDiscountType: 1,
      CFOP: e.CFOP,
      CofinsPercentage: e.CofinsPercentage,
      CofinsType: e.CofinsType,
      Comments: e.Comments,
      CSTPisCofins: e.CSTPisCofins,
      IcmsAliquot: e.IcmsAliquot,
      IcmsFiscalAdjustCode: e.IcmsFiscalAdjustCode,
      IcmsFiscalAdjustObservationCode: e.IcmsFiscalAdjustObservationCode,
      IcmsFiscalBenefitCode: e.IcmsFiscalBenefitCode,
      IcmsFiscalOriginalAliquot: e.IcmsFiscalOriginalAliquot,
      IcmsIVAMargin: e.IcmsIVAMargin,
      IcmsReductionMargin: e.IcmsReductionMargin,
      IcmsStave: e.IcmsStave,
      IcmsTributarySituationCode: e.IcmsTributarySituationCode,
      LiquidCost: e.LiquidCost,
      LiquidCostMiddle: e.LiquidCostMiddle,
      LiquidCostReal: e.LiquidCostReal,
      NatureOperationCodePisCofins: e.NatureOperationCodePisCofins,
      OfferECommercePrice: e.OfferECommercePrice,
      OfferRetailPrice: e.OfferRetailPrice,
      PisPercentage: e.PisPercentage,
      PisType: e.PisType,
      Position: ++position,
      ProductEan: e.ProductEan,
      ProductInternalCodeOnERP: e.ProductInternalCodeOnERP,
      ProductIsFatherComposition: e.ProductIsFatherComposition,
      ProductName: e.ProductName,
      ProductPluCode: e.ProductPluCode,
      Quantity: e.Quantity,
      RepositionCost: e.RepositionCost,
      RepositionCostMiddle: e.RepositionCostMiddle,
      RepositionCostReal: e.RepositionCostReal,
      SaleECommercePrice: e.SaleECommercePrice,
      SaleMovement: null,
      SaleMovementProductCompositionId: e.ProductIsFatherComposition == true
          ? e.SaleMovementProductId?.toString()
          : e.SaleMovementProductCompositionId,
      SaleMovementProductId: 0,
      SaleRequestProductInternalCodeOnERP: e.ProductInternalCodeOnERP?.toInt(),
      SaleRetailPrice: e.SaleRetailPrice,
      SocialContributionCodePisCofins: e.SocialContributionCodePisCofins,
      UnitValue: e.UnitValue,
      WholeOfferPrice: e.WholeOfferPrice,
      WholeSalePrice: e.WholeSalePrice,
      SaleNegotiationDiscountType: null,
      SaleNegotiationDiscountValue: null,
      SaleOfferCode: null,
      SaleOfferDiscountType: null,
      SaleOfferDiscountValue: null,
      SaleOfferQuantity: null,
      UserIdOfCancellation: null,
      UserIdOfDiscount: null,
      CRMDiscountType: null,
      CRMDiscountValue: null,
      DeliveryTaxType: null,
      DeliveryTaxValue: null,
      DiscountType: null,
      DiscountValue: null,
      IncrementType: null,
      IncrementValue: null,
      MotiveJustificationId: null,
      MotiveJustificationName: null,
      MotiveJustificationSaleDiscountId: null,
      MotiveJustificationSaleDiscountName: null,
      IsCancelled: false,
      IsPrinted: false,
      IsToDelivery: false,
      // SaleMovementProducOfFatherComposition: null,
    );
  }).toList();
}

enum SaleFiscalType {
  sat,
  nfce,
  satEmulador,
  nfceContingencyOffLine,
  nfceContingencyOffLineOnPdv,
  nfceEmulador,
}

extension SaleFiscalTypeExtension on SaleFiscalType {
  int get id {
    switch (this) {
      case SaleFiscalType.sat:
        return 1;
      case SaleFiscalType.nfce:
        return 2;
      case SaleFiscalType.satEmulador:
        return 3;
      case SaleFiscalType.nfceContingencyOffLine:
        return 4;
      case SaleFiscalType.nfceContingencyOffLineOnPdv:
        return 5;
      case SaleFiscalType.nfceEmulador:
        return 6;
    }
  }
}
