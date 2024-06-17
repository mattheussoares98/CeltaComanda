// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';

import '../pages.dart';

class ConfirmedComboxViewModel extends Equatable {
  final List<ProductCompositionViewModel> products;
  final ProductsViewModel father;
  final double totalPrice;

  const ConfirmedComboxViewModel({
    required this.products,
    required this.father,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [products, father, totalPrice];

  factory ConfirmedComboxViewModel.fromJson(Map json) {
    return ConfirmedComboxViewModel(
      products: json["products"]
          .map<ProductCompositionViewModel>(
              (element) => ProductCompositionViewModel.fromJson(element))
          .toList(),
      father: ProductsViewModel.fromJson(json["father"]),
      totalPrice: json["totalPrice"],
    );
  }

  Map toJson() => {
        "products": products,
        "father": father,
        "totalPrice": totalPrice,
      };
}
