

import 'package:equatable/equatable.dart';

class UpdateSaleRequestTempProductEntity extends Equatable {
  final int ProductInternalCodeOnErp;
  final String ProductPriceLookUpCode;
  final double Quantity;
  final int SaleRequestTempId;
  final double TotalLiquid;
  final double Value;
  final String? Comments;
  final int? SaleRequestProductIdOfFather;
  final bool? ProductIsFatherComposition;

  const UpdateSaleRequestTempProductEntity({
    required this.ProductInternalCodeOnErp,
    required this.ProductPriceLookUpCode,
    required this.Quantity,
    required this.SaleRequestTempId,
    required this.TotalLiquid,
    required this.Value,
    required this.Comments,
    required this.SaleRequestProductIdOfFather,
    required this.ProductIsFatherComposition,
  });

  @override
  List<Object?> get props => [
        ProductInternalCodeOnErp,
        ProductPriceLookUpCode,
        Quantity,
        SaleRequestTempId,
        TotalLiquid,
        Value,
        Comments,
        SaleRequestProductIdOfFather,
        ProductIsFatherComposition,
      ];
}
