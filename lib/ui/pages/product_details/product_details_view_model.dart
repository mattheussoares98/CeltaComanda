import 'package:equatable/equatable.dart';

class ProductDetailsViewModel extends Equatable {
  final String price;
  final String name;
  final String image;

  @override
  List get props => [price, name, image];

  const ProductDetailsViewModel({
    required this.price,
    required this.name,
    required this.image,
  });
}
