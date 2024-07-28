// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';

import '../pages.dart';

class ConfirmedComboxViewModel extends Equatable {
  final List<InsertProductsViewModel> products;
  final ProductsViewModel father;
  final double totalPrice;
  final int quantity;

  const ConfirmedComboxViewModel({
    required this.products,
    required this.father,
    required this.totalPrice,
    required this.quantity,
  });

  @override
  List<Object?> get props => [products, father, totalPrice];

  factory ConfirmedComboxViewModel.fromJson(Map json) {
    return ConfirmedComboxViewModel(
      products: json["products"]
          .map<InsertProductsViewModel>(
              (element) => InsertProductsViewModel.fromJson(element))
          .toList(),
      father: ProductsViewModel.fromJson(json["father"]),
      totalPrice: json["totalPrice"],
      quantity: json["quantity"],
    );
  }

  Map toJson() => {
        "products": products,
        "father": father,
        "totalPrice": totalPrice,
        "quantity": quantity,
      };
}
