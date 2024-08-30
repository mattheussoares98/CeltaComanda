// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class SuggestionSaleModel {
  final int ProductPackingCode;
  final int ProductPackingCodeSuggestionForSale;
  SuggestionSaleModel({
    required this.ProductPackingCode,
    required this.ProductPackingCodeSuggestionForSale,
  });

  factory SuggestionSaleModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'ProductPackingCode',
      'ProductPackingCodeSuggestionForSale',
    ])) {
      throw Exception();
    }
    return SuggestionSaleModel(
      ProductPackingCode: json['ProductPackingCode'],
      ProductPackingCodeSuggestionForSale: json['ProductPackingCodeSuggestionForSale'],
    );
  }

  factory SuggestionSaleModel.fromEntity(SuggestionSaleEntity entity) => SuggestionSaleModel(
        ProductPackingCode: entity.ProductPackingCode,
        ProductPackingCodeSuggestionForSale: entity.ProductPackingCodeSuggestionForSale,
      );

  SuggestionSaleEntity toEntity() => SuggestionSaleEntity(
        ProductPackingCode: ProductPackingCode,
        ProductPackingCodeSuggestionForSale: ProductPackingCodeSuggestionForSale,
      );

  Map<String, dynamic> toJson() => {
        "ProductPackingCode": ProductPackingCode,
        "ProductPackingCodeSuggestionForSale": ProductPackingCodeSuggestionForSale,
      };
}
