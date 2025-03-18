import 'dart:convert';

import 'package:xml2json/xml2json.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
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
    required int couponFiscalNumber,
    required List<ConcentratorFinalizationEntity> finalizations,
    required List<PrintedProductsViewModel> products,
    required String? xmlToGenerateFiscal,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url =
          "${EnterpriseBuilder.entity!.concentradorUrl}/api/APISaleMovement/Insert";

      String? eletronicAccessKey;
      if (xmlToGenerateFiscal != null) {
        final Xml2Json xml2json = Xml2Json();
        xml2json.parse(xmlToGenerateFiscal);
        final mapAsString = xml2json.toParker();
        Map<String, dynamic> parsedJson = json.decode(mapAsString);
        eletronicAccessKey = parsedJson["CeltaBSResponse"]["NFCe"]
            ["fiscalNoteConsumerEletronicKeyAccess"];
      }

      final saleMovement = _createSaleMovementEntity(
        eletronicAccessKey: eletronicAccessKey,
        couponFiscalNumber: couponFiscalNumber,
        pdvId: pdvId,
        pdvNumber: pdvNumber.padLeft(3, "0"),
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
    required int couponFiscalNumber,
    required String? eletronicAccessKey,
    required List<ConcentratorFinalizationEntity> finalizations,
    required List<PrintedProductsViewModel> products,
  }) {
    final enterprise = EnterpriseBuilder.entity;
    final atualDate = DateTime.now();
    final personalizedCode = atualDate.year.toString() +
        atualDate.month.toString().padLeft(2, "0") +
        atualDate.day.toString().padLeft(2, "0") +
        pdvNumber.padLeft(3, "0") +
        couponFiscalNumber.toString().padLeft(4, "0");
    return SaleMovementConcentratorEntity(
      Checks: [],
      Portions: [],
      XmlSatNfce: xml,
      SaleFiscalTypeString: xml == null ? "Venda" : "NFCe",
      SaleFiscalType:
          xml == null ? SaleFiscalType.nfceEmulador.id : SaleFiscalType.nfce.id,
      EletronicAccessKey: eletronicAccessKey,
      SaleMovementId: 0,
      PdvId: pdvId,
      PdvNumber: pdvNumber,
      CovenantCode: covenantCode,
      CustomerCode: customerCode,
      CpfCnpj: cpfCnpj,
      DateHourOfCreation: atualDate.toIso8601String(),
      DateHourOfDelivery: null,
      DateOfCreation: atualDate.toIso8601String(),
      EnterpriseCode: enterprise
          ?.enterpriseConcentradorParametersEntity?.enterprise?.enterpriseCode,
      EnterpriseId: enterprise?.enterpriseId,
      IncrementType: incrementType,
      IncrementValue: incrementValue,
      RoundingType: 1,
      SalePricePraticed: 1,
      TotalLiquid: totalLiquid,
      Finalizations: _getFinalizations(
        finalizations: finalizations,
        totalLiquid: totalLiquid,
      ),
      Products: _getProducts(products: products),
      SaleRequestPersonalizedCode: null,
      SellerCode: /* seller != null ? seller.SellersId : (int?)null */ null,
      SellerName: /* seller != null ? seller.Name : null */ null,
      PersonalizedCode: personalizedCode,
      MotiveJustificationName: null,
      MotiveJustificationId: null,
      CashierMovementId: null,
      CustomerAdditionalCode: null,
      CRMCpfCnpj: null,
      CRMDiscountTransactionId: null,
      CRMDiscountType: null,
      CRMDiscountValue: null,
      DeliveryControl: 0,
      DiscountFinalizationValue: 0,
      DiscountType: null,
      DiscountValue: null,
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
      CouponFiscalNumber: couponFiscalNumber,
    );
  }
}

List<ConcentratorFinalizationEntity> _getFinalizations({
  required List<ConcentratorFinalizationEntity> finalizations,
  required double totalLiquid,
}) =>
    finalizations.isEmpty
        ? [
            ConcentratorFinalizationEntity(
              FinalizationId: FinalizationType.money.id,
              PortionQuantity: null,
              Value: totalLiquid,
              ValueLiquid: totalLiquid,
              SaleMovementFinalizationId: 0,
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
  required List<PrintedProductsViewModel> products,
}) {
  return products.map((e) {
    int position = 1;
    final product = e.toEntity();
    final productEntity = product.Product;

    return SaleMovementProductConcentratorEntity(
      BlockadeDiscountType: 1,
      CFOP: productEntity?.CFOP,
      CofinsPercentage: productEntity?.CofinsPercentage,
      CofinsType: productEntity?.CofinsType,
      Comments: product.Comments ?? "",
      CSTPisCofins: productEntity?.CSTPisCofins,
      IcmsAliquot: productEntity?.IcmsAliquot,
      IcmsFiscalAdjustCode: null /*  */,
      IcmsFiscalAdjustObservationCode: null /*  */,
      IcmsFiscalBenefitCode: null /*  */,
      IcmsFiscalOriginalAliquot: null /*  */,
      NatureOperationCodePisCofins: null /*  */,
      IcmsTributarySituationCode: e.Product?.TributarySituationCode,
      UnitValue: productEntity?.SaleRetailPraticed,
      WholeOfferPrice: productEntity?.WholeOfferPrice,
      WholeSalePrice: productEntity?.WholeSalePrice,
      IcmsIVAMargin: productEntity?.IcmsIVAMargin,
      IcmsReductionMargin: productEntity?.IcmsReductionMargin,
      IcmsStave: productEntity?.IcmsStave,
      LiquidCost: productEntity?.LiquidCost,
      LiquidCostMiddle: productEntity?.LiquidCostMiddle,
      LiquidCostReal: productEntity?.LiquidCostReal,
      OfferECommercePrice: productEntity?.OfferECommercePrice,
      OfferRetailPrice: productEntity?.OfferRetailPrice,
      PisPercentage: productEntity?.PisPercentage,
      PisType: productEntity?.PisType,
      Position: ++position,
      ProductEan: productEntity?.EanCode,
      ProductInternalCodeOnERP:
          productEntity?.InternalCodeOfProductOnERP?.toString(),
      ProductIsFatherComposition: productEntity?.ProductIsFatherComposition == 1,
      ProductName: productEntity?.Name,
      ProductPluCode: productEntity?.PriceLookupCode,
      Quantity: e.Quantity?.toDouble(),
      RepositionCost: productEntity?.RepositionCost,
      RepositionCostMiddle: productEntity?.RepositionCostMiddle,
      RepositionCostReal: productEntity?.RepositionCostReal,
      SaleECommercePrice: productEntity?.SaleECommercePrice,
      SaleMovement: null,
      SaleMovementProductCompositionId:
          null /* e.ProductIsFatherComposition == true
          ? e.SaleMovementProductId?.toString()
          : e.SaleMovementProductCompositionId */
      ,
      SaleMovementProductId: 0,
      SaleRetailPrice: productEntity?.SaleRetailPrice,
      SaleRequestProductInternalCodeOnERP: null,
      SocialContributionCodePisCofins: null,
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
