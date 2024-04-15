import 'package:equatable/equatable.dart';

class ProductsViewModel extends Equatable {
  final String image;
  final String price;
  final String name;
  final String plu;

  const ProductsViewModel({
    required this.image,
    required this.price,
    required this.name,
    required this.plu,
  });

  @override
  List<Object?> get props => [image, price, name, plu];
}
