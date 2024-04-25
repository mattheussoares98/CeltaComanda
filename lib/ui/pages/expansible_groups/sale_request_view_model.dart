// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../pages.dart';

class SaleRequestTempViewModel extends Equatable {
  final List<ProductsViewModel> Products;
  final String PersonalizedCode;
  final int EnterpriseId;
  final double TotalLiquid;
  final int DeliveryControl;
  final String? Comments;

  @override
  List get props => [
        Products,
        PersonalizedCode,
        EnterpriseId,
        TotalLiquid,
        DeliveryControl,
        Comments,
      ];

  const SaleRequestTempViewModel({
    required this.Products,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    this.Comments,
  });

  factory SaleRequestTempViewModel.fromEntity(SaleRequestTempEntity entity) =>
      SaleRequestTempViewModel(
        Products: entity.Products.map((e) => ProductsViewModel(
              PriceLookupCode: e.PriceLookupCode,
              Name: e.Name,
              PackingAbbreviation: e.PackingAbbreviation,
              CFOP: e.CFOP,
              FiscalClassificationNCM: e.FiscalClassificationNCM,
              TributarySituationCode: e.TributarySituationCode,
              CSTPisCofins: e.CSTPisCofins,
              CodeClass: e.CodeClass,
              DepartmentName: e.DepartmentName,
              SectionName: e.SectionName,
              DateOfLastChanged: e.DateOfLastChanged,
              GroupName: e.GroupName,
              SaleRetailPraticedString: e.SaleRetailPraticedString,
              PersonalizedCode: e.PersonalizedCode,
              EanCode: e.EanCode,
              NameComplete: e.NameComplete,
              NameReduced: e.NameReduced,
              ProductsId: e.ProductsId.toString(),
              SaleRetailPraticed: e.SaleRetailPraticed.toString(),
              InternalCodeOnERP: e.InternalCodeOnERP.toString(),
              InternalCodeOfProductOnERP:
                  e.InternalCodeOfProductOnERP.toString(),
              EenterpriseId: e.EenterpriseId.toString(),
              PackingQuantity: e.PackingQuantity.toString(),
              OfferRetailPrice: e.OfferRetailPrice.toString(),
              WholeSalePrice: e.WholeSalePrice.toString(),
              WholeOfferPrice: e.WholeOfferPrice.toString(),
              OfferECommercePrice: e.OfferECommercePrice.toString(),
              SaleECommercePrice: e.SaleECommercePrice.toString(),
              LiquidCost: e.LiquidCost.toString(),
              LiquidCostMiddle: e.LiquidCostMiddle.toString(),
              LiquidCostReal: e.LiquidCostReal.toString(),
              RepositionCost: e.RepositionCost.toString(),
              RepositionCostMiddle: e.RepositionCostMiddle.toString(),
              RepositionCostReal: e.RepositionCostReal.toString(),
              IcmsAliquot: e.IcmsAliquot.toString(),
              IcmsIVAMargin: e.IcmsIVAMargin.toString(),
              IcmsReductionMargin: e.IcmsReductionMargin.toString(),
              IcmsStave: e.IcmsStave.toString(),
              PercImpNBPTState: e.PercImpNBPTState.toString(),
              PercImpNBPTMunicipal: e.PercImpNBPTMunicipal.toString(),
              CofinsType: e.CofinsType.toString(),
              PisType: e.PisType.toString(),
              ProductIsFatherComposition:
                  e.ProductIsFatherComposition.toString(),
              QuantityMinimumWholeSale: e.QuantityMinimumWholeSale.toString(),
              QuantityMinimumWholeSaleByClass:
                  e.QuantityMinimumWholeSaleByClass.toString(),
              BalanceTare: e.BalanceTare.toString(),
              FamilyCode: e.FamilyCode.toString(),
              DepartmentCode: e.DepartmentCode.toString(),
              SectionCode: e.SectionCode.toString(),
              GroupCode: e.GroupCode.toString(),
              SubGroupCode: e.SubGroupCode.toString(),
              StockQuantity: e.StockQuantity.toString(),
              AllowFractionate: e.AllowFractionate.toString(),
              IsBalance: e.IsBalance.toString(),
              CanBeWeightyInPdv: e.CanBeWeightyInPdv.toString(),
              QuantityInBalance: e.QuantityInBalance.toString(),
              AllowQuantityInPdv: e.AllowQuantityInPdv.toString(),
              GoesForFastTable: e.GoesForFastTable.toString(),
              IsAlcoholicProduct: e.IsAlcoholicProduct.toString(),
              SaleRetailPrice: e.SaleRetailPrice.toString(),
              PercImpNBPTNational: e.PercImpNBPTNational.toString(),
              CofinsPercentage: e.CofinsPercentage.toString(),
              PisPercentage: e.PisPercentage.toString(),
            )).toList(),
        PersonalizedCode: entity.PersonalizedCode,
        EnterpriseId: entity.EnterpriseId,
        TotalLiquid: entity.TotalLiquid,
        DeliveryControl: entity.DeliveryControl,
        Comments: entity.Comments,
      );
}
