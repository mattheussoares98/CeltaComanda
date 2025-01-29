import 'package:equatable/equatable.dart';

class LastImportEntity extends Equatable {
  final DateTime? products;
  final DateTime? images;

  const LastImportEntity({
    required this.products,
    required this.images,
  });

  @override
  List<Object?> get props => [products, images];
}
