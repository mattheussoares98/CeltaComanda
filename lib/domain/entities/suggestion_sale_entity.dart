// ignore_for_file: non_constant_identifier_names
import 'package:equatable/equatable.dart';

class SuggestionSaleEntity extends Equatable {
  final int ProductPackingCode;
  final int ProductPackingCodeSuggestionForSale;

  const SuggestionSaleEntity({
    required this.ProductPackingCode,
    required this.ProductPackingCodeSuggestionForSale,
  });

  @override
  List get props => [ProductPackingCode, ProductPackingCodeSuggestionForSale];
}
