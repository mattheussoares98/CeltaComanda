// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';
import 'product_model.dart';

class SaleRequestTempProductsModel {
  final ProductModel Product;
  final int SaleRequestProductTempId;
  final bool IsPrinted;
  final String? Comments;
  final int SaleRequestTempId;
  final int ProductInternalCodeOnErp;
  final double TotalLiquid;
  final double Quantity;
  final double Value;
  final String ProductPriceLookUpCode;

  SaleRequestTempProductsModel({
    required this.Product,
    required this.SaleRequestProductTempId,
    required this.IsPrinted,
    required this.Comments,
    required this.SaleRequestTempId,
    required this.ProductInternalCodeOnErp,
    required this.TotalLiquid,
    required this.Quantity,
    required this.Value,
    required this.ProductPriceLookUpCode,
  });

  factory SaleRequestTempProductsModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys.toSet().containsAll(
      [
        "Product",
        "SaleRequestProductTempId",
        "IsPrinted",
        "Comments",
        "SaleRequestTempId",
        "ProductInternalCodeOnErp",
        "TotalLiquid",
        "Quantity",
        "Value",
        "ProductPriceLookUpCode",
      ],
    )) {
      throw Exception();
    }

    return SaleRequestTempProductsModel(
      Product: ProductModel.fromJson(json["Product"]),
      SaleRequestProductTempId: json["SaleRequestProductTempId"],
      IsPrinted: json["IsPrinted"],
      Comments: json["Comments"],
      SaleRequestTempId: json["SaleRequestTempId"],
      ProductInternalCodeOnErp: json["ProductInternalCodeOnErp"],
      TotalLiquid: json["TotalLiquid"],
      Quantity: json["Quantity"],
      Value: json["Value"],
      ProductPriceLookUpCode: json["ProductPriceLookUpCode"],
    );
  }

  factory SaleRequestTempProductsModel.fromEntity(
      SaleRequestTempProductEntity entity) {
    return SaleRequestTempProductsModel(
      Product: ProductModel.fromEntity(entity.Product),
      SaleRequestProductTempId: entity.SaleRequestProductTempId,
      IsPrinted: entity.IsPrinted,
      Comments: entity.Comments.toString(),
      SaleRequestTempId: entity.SaleRequestTempId,
      ProductInternalCodeOnErp: entity.ProductInternalCodeOnErp,
      TotalLiquid: entity.TotalLiquid,
      Quantity: entity.Quantity,
      Value: entity.Value,
      ProductPriceLookUpCode: entity.ProductPriceLookUpCode,
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['ProductsId'] = ProductsId;
  //   data['InternalCodeOnERP'] = InternalCodeOnERP;
  //   data['InternalCodeOfProductOnERP'] = InternalCodeOfProductOnERP;
  //   data['EnterpriseId'] = EnterpriseId;
  //   data['PriceLookupCode'] = PriceLookupCode;
  //   data['PersonalizedCode'] = PersonalizedCode;
  //   data['EanCode'] = EanCode;
  //   data['Name'] = Name;
  //   data['NameComplete'] = NameComplete;
  //   data['NameReduced'] = NameReduced;
  //   data['PackingAbbreviation'] = PackingAbbreviation;
  //   data['PackingQuantity'] = PackingQuantity;
  //   data['SaleRetailPrice'] = SaleRetailPrice;
  //   data['OfferRetailPrice'] = OfferRetailPrice;
  //   data['WholeSalePrice'] = WholeSalePrice;
  //   data['WholeOfferPrice'] = WholeOfferPrice;
  //   data['OfferECommercePrice'] = OfferECommercePrice;
  //   data['SaleECommercePrice'] = SaleECommercePrice;
  //   data['LiquidCost'] = LiquidCost;
  //   data['LiquidCostMiddle'] = LiquidCostMiddle;
  //   data['LiquidCostReal'] = LiquidCostReal;
  //   data['RepositionCost'] = RepositionCost;
  //   data['RepositionCostMiddle'] = RepositionCostMiddle;
  //   data['RepositionCostReal'] = RepositionCostReal;
  //   data['CFOP'] = CFOP;
  //   data['FiscalClassificationNCM'] = FiscalClassificationNCM;
  //   data['TributarySituationCode'] = TributarySituationCode;
  //   data['IcmsAliquot'] = IcmsAliquot;
  //   data['IcmsIVAMargin'] = IcmsIVAMargin;
  //   data['IcmsReductionMargin'] = IcmsReductionMargin;
  //   data['IcmsStave'] = IcmsStave;
  //   data['PercImpNBPTNational'] = PercImpNBPTNational;
  //   data['PercImpNBPTState'] = PercImpNBPTState;
  //   data['PercImpNBPTMunicipal'] = PercImpNBPTMunicipal;
  //   data['CofinsPercentage'] = CofinsPercentage;
  //   data['PisPercentage'] = PisPercentage;
  //   data['CofinsType'] = CofinsType;
  //   data['PisType'] = PisType;
  //   data['CSTPisCofins'] = CSTPisCofins;
  //   data['ProductIsFatherComposition'] = ProductIsFatherComposition;
  //   data['QuantityMinimumWholeSale'] = QuantityMinimumWholeSale;
  //   data['QuantityMinimumWholeSaleByClass'] = QuantityMinimumWholeSaleByClass;
  //   data['AllowFractionate'] = AllowFractionate;
  //   data['IsBalance'] = IsBalance;
  //   data['CanBeWeightyInPdv'] = CanBeWeightyInPdv;
  //   data['QuantityInBalance'] = QuantityInBalance;
  //   data['AllowQuantityInPdv'] = AllowQuantityInPdv;
  //   data['GoesForFastTable'] = GoesForFastTable;
  //   data['IsAlcoholicProduct'] = IsAlcoholicProduct;
  //   data['BalanceTare'] = BalanceTare;
  //   data['CodeClass'] = CodeClass;
  //   data['FamilyCode'] = FamilyCode;
  //   data['DepartmentCode'] = DepartmentCode;
  //   data['DepartmentName'] = DepartmentName;
  //   data['SectionCode'] = SectionCode;
  //   data['SectionName'] = SectionName;
  //   data['GroupCode'] = GroupCode;
  //   data['GroupName'] = GroupName;
  //   data['SubGroupCode'] = SubGroupCode;
  //   data['DateOfLastChanged'] = DateOfLastChanged;
  //   data['StockQuantity'] = StockQuantity;
  //   data['SaleRetailPraticed'] = SaleRetailPraticed;
  //   data['SaleRetailPraticedString'] = SaleRetailPraticedString;
  //   return data;
  // }

  SaleRequestTempProductEntity toEntity() => SaleRequestTempProductEntity(
        Product: Product.toEntity(),
        SaleRequestProductTempId: SaleRequestProductTempId,
        IsPrinted: IsPrinted,
        SaleRequestTempId: SaleRequestTempId,
        ProductInternalCodeOnErp: ProductInternalCodeOnErp,
        TotalLiquid: TotalLiquid,
        Quantity: Quantity,
        Value: Value,
        ProductPriceLookUpCode: ProductPriceLookUpCode,
      );
}
