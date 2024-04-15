import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String image;
  final double price;
  final String name;
  final String plu;

  const ProductEntity({
    required this.image,
    required this.price,
    required this.name,
    required this.plu,
  });

  @override
  List<Object?> get props => [image, price, name, plu];
}
