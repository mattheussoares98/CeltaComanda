// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class UpdateSaleRequestTempProductEntity extends Equatable {
  final int ProductInternalCodeOnErp;
  final String ProductPriceLookUpCode;
  final double Quantity;
  final int SaleRequestTempId;
  final double TotalLiquid;
  final double Value;

  const UpdateSaleRequestTempProductEntity({
    required this.ProductInternalCodeOnErp,
    required this.ProductPriceLookUpCode,
    required this.Quantity,
    required this.SaleRequestTempId,
    required this.TotalLiquid,
    required this.Value,
  });

  @override
  List<Object?> get props => [
        ProductInternalCodeOnErp,
        ProductPriceLookUpCode,
        Quantity,
        SaleRequestTempId,
        TotalLiquid,
        Value,
      ];
}
