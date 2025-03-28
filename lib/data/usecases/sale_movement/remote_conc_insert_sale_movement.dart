import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
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

    final correctProducts = _getProductsToInsertInConcentrator(products);

    return SaleMovementConcentratorEntity(
      Checks: [],
      Portions: [],
      XmlSatNfce: xml,
      SaleFiscalTypeString: xml == null ? "Venda" : "NFCe",
      SaleFiscalType:
          xml == null ? SaleFiscalType.nfceEmulador.id : SaleFiscalType.nfce.id,
      EletronicAccessKey: eletronicAccessKey,
      SaleMovementId: null,
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
      Products: correctProducts,
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
      WasPrinted: true,
      MotiveJustificationSaleDiscountId: null,
      MotiveJustificationSaleDiscountName: null,
      UserIdOfCancellation: null,
      UserIdOfDiscount: null,
      XmlSatNfceCancel: null,
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

List<SaleMovementProductConcentratorEntity> _getProductsToInsertInConcentrator(
  List<PrintedProductsViewModel> products,
) {
  List<SaleMovementProductConcentratorEntity> saleMovementProducts = [];
  try {
    int position = 1;

    for (var product in products) {
      final product1 = product.toEntity();
      final productEntity = product1.Product;
      final productFatherId =
          (DateTime.now().millisecondsSinceEpoch + Random().nextInt(999999))
              .toString();

      saleMovementProducts.add(
        SaleMovementProductConcentratorEntity(
          UnitValue: product1.Value?.toDouble(),
          SaleMovementProductCompositionId:
              product1.ProductIsFatherComposition == true
                  ? productFatherId
                  : null,
          SaleMovementProductId: 0,
          Position: position++,
          BlockadeDiscountType: 1,
          CFOP: productEntity?.CFOP,
          CofinsPercentage: productEntity?.CofinsPercentage,
          CofinsType: productEntity?.CofinsType,
          Comments: product1.Comments ?? "",
          CSTPisCofins: productEntity?.CSTPisCofins,
          IcmsAliquot: productEntity?.IcmsAliquot,
          IcmsFiscalAdjustCode: null /*  */,
          IcmsFiscalAdjustObservationCode: null /*  */,
          IcmsFiscalBenefitCode: null /*  */,
          IcmsFiscalOriginalAliquot: null /*  */,
          NatureOperationCodePisCofins: null /*  */,
          IcmsTributarySituationCode: product1.Product?.TributarySituationCode,
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
          ProductEan: productEntity?.EanCode,
          ProductInternalCodeOnERP:
              productEntity?.InternalCodeOfProductOnERP?.toString(),
          ProductIsFatherComposition:
              productEntity?.ProductIsFatherComposition == 1,
          ProductName: productEntity?.Name,
          ProductPluCode: productEntity?.PriceLookupCode,
          Quantity: product1.Quantity?.toDouble(),
          RepositionCost: productEntity?.RepositionCost,
          RepositionCostMiddle: productEntity?.RepositionCostMiddle,
          RepositionCostReal: productEntity?.RepositionCostReal,
          SaleECommercePrice: productEntity?.SaleECommercePrice,
          SaleRetailPrice: productEntity?.SaleRetailPrice,
          UserIdOfCancellation: product1.UserIdOfCancellation?.toInt(),
          IsCancelled: product1.IsCancelled,
          SaleMovement: null,
          SaleRequestProductInternalCodeOnERP: null,
          SocialContributionCodePisCofins: null,
          SaleNegotiationDiscountType: null,
          SaleNegotiationDiscountValue: null,
          SaleOfferCode: null,
          SaleOfferDiscountType: null,
          SaleOfferDiscountValue: null,
          SaleOfferQuantity: null,
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
          IsPrinted: false,
          IsToDelivery: false,
          // SaleMovementProducOfFatherComposition: null,
        ),
      );

      if (product.ProductIsFatherComposition == "true" &&
          product.childs.isNotEmpty) {
        for (var child in product.childs) {
          saleMovementProducts.add(
            SaleMovementProductConcentratorEntity(
              Position: position++,
              SaleMovementProductId: 0,
              SaleMovementProductCompositionId:
                  productFatherId, //precisa ser do pai
              IsCancelled: product1.IsCancelled, //precisa ser do pai
              SaleRequestProductInternalCodeOnERP: null,
              UnitValue: child.Value?.toDouble(),
              Quantity: child.Quantity?.toDouble(),
              IsToDelivery: false,
              IsPrinted: false,
              Comments: child.Comments,
              UserIdOfCancellation: child.UserIdOfCancellation?.toInt(),
              ProductPluCode: child.Product?.PriceLookupCode,
              ProductEan: child.Product?.EanCode,
              ProductInternalCodeOnERP: child.Product?.InternalCodeOnERP,
              ProductName: child.Product?.Name,
              ProductIsFatherComposition: false,
              IcmsTributarySituationCode: child.Product?.TributarySituationCode,
              IcmsAliquot: child.Product?.IcmsAliquot?.toDouble(),
              IcmsStave: child.Product?.IcmsStave?.toDouble(),
              IcmsReductionMargin:
                  child.Product?.IcmsReductionMargin?.toDouble(),
              IcmsIVAMargin: child.Product?.IcmsIVAMargin?.toDouble(),
              PisType: child.Product?.PisType?.toInt(),
              CofinsType: child.Product?.CofinsType?.toInt(),
              BlockadeDiscountType: 1,
              PisPercentage: child.Product?.PisPercentage?.toDouble(),
              CofinsPercentage: child.Product?.CofinsPercentage?.toDouble(),
              SaleRetailPrice: child.Product?.SaleRetailPrice?.toDouble(),
              OfferRetailPrice: child.Product?.OfferRetailPrice?.toDouble(),
              WholeSalePrice: child.Product?.WholeSalePrice?.toDouble(),
              WholeOfferPrice: child.Product?.WholeOfferPrice?.toDouble(),
              SaleECommercePrice: child.Product?.SaleECommercePrice?.toDouble(),
              OfferECommercePrice:
                  child.Product?.OfferECommercePrice?.toDouble(),
              RepositionCost: child.Product?.RepositionCost?.toDouble(),
              RepositionCostMiddle:
                  child.Product?.RepositionCostMiddle?.toDouble(),
              LiquidCost: child.Product?.LiquidCost?.toDouble(),
              LiquidCostMiddle: child.Product?.LiquidCostMiddle?.toDouble(),
              RepositionCostReal: child.Product?.RepositionCostReal?.toDouble(),
              LiquidCostReal: child.Product?.LiquidCostReal?.toDouble(),
              CFOP: child.Product?.CFOP,
              CSTPisCofins: child.Product?.CSTPisCofins,
              NatureOperationCodePisCofins: null,
              SocialContributionCodePisCofins: null,
              IcmsFiscalAdjustCode: null,
              IcmsFiscalAdjustObservationCode: null,
              IcmsFiscalOriginalAliquot: null,
              IcmsFiscalBenefitCode: null,
              SaleOfferCode: null,
              SaleOfferQuantity: null,
              SaleOfferDiscountType: null,
              SaleOfferDiscountValue: null,
              SaleMovement: null,
              MotiveJustificationId: null,
              MotiveJustificationName: null,
              MotiveJustificationSaleDiscountId: null,
              MotiveJustificationSaleDiscountName: null,
              DiscountType: null,
              DiscountValue: null,
              UserIdOfDiscount: null,
              SaleNegotiationDiscountType: null,
              SaleNegotiationDiscountValue: null,
              CRMDiscountType: null,
              CRMDiscountValue: null,
              IncrementType: null,
              IncrementValue: null,
              DeliveryTaxType: null,
              DeliveryTaxValue: null,
            ),
          );
        }
      }
    }

    return saleMovementProducts;
  } catch (e) {
    debugPrint(e.toString());
    throw Exception();
  }
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
