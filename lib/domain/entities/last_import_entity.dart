import 'package:equatable/equatable.dart';

class LastImportEntity extends Equatable {
  final DateTime? products;
  final DateTime? images;
  final DateTime? users;
  final DateTime? enterprise;

  const LastImportEntity({
    required this.products,
    required this.images,
    required this.users,
    required this.enterprise,
  });

  @override
  List<Object?> get props => [
        products,
        images,
        users,
        enterprise,
      ];
}
