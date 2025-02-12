import 'package:equatable/equatable.dart';

class LastImportEntity extends Equatable {
  final DateTime? products;
  final DateTime? images;
  final DateTime? users;

  const LastImportEntity({
    required this.products,
    required this.images,
    required this.users,
  });

  @override
  List<Object?> get props => [products, images, users];
}
