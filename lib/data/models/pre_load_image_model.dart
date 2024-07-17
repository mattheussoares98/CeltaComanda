import 'package:clean_celta_mobile/domain/entities/entities.dart';

import '../../ui/pages/pages.dart';

class PreLoadImageModel {
  final String? ean;
  final String plu;

  PreLoadImageModel({
    required this.ean,
    required this.plu,
  });

  factory PreLoadImageModel.fromProductsViewModel(ProductsViewModel product) =>
      PreLoadImageModel(
        ean: product.EanCode,
        plu: product.PriceLookupCode,
      );

  PreLoadImageEntity toEntity() => PreLoadImageEntity(ean: ean, plu: plu);
}
