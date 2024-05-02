// ignore_for_file: non_constant_identifier_names

class UpdateSaleRequestTempProductEntity {
  final int ProductInternalCodeOnErp;
  final String ProductPriceLookUpCode;
  final int Quantity;
  final int SaleRequestTempId;
  final double TotalLiquid;
  final double Value;

  UpdateSaleRequestTempProductEntity({
    required this.ProductInternalCodeOnErp,
    required this.ProductPriceLookUpCode,
    required this.Quantity,
    required this.SaleRequestTempId,
    required this.TotalLiquid,
    required this.Value,
  });
}
