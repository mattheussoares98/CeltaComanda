import 'package:equatable/equatable.dart';

class ProductsViewModel extends Equatable {
  final double price;
  final String name;
  final String image;

  @override
  List get props => [price, name, image];

  const ProductsViewModel({
    required this.price,
    required this.name,
    required this.image,
  });
}
