// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class ProductsViewModel extends Equatable {
  final String SaleRetailPraticed;
  final String PackingAbbreviation;
  final String Name;
  final String EanCode;
  final String PriceLookupCode;
  final int ProductsId;

  const ProductsViewModel({
    required this.SaleRetailPraticed,
    required this.PackingAbbreviation,
    required this.Name,
    required this.EanCode,
    required this.PriceLookupCode,
    required this.ProductsId,
  });

  @override
  List<Object?> get props => [
        SaleRetailPraticed,
        PackingAbbreviation,
        Name,
        EanCode,
        PriceLookupCode,
        ProductsId,
      ];
}
