import 'package:equatable/equatable.dart';

class LastImportEntity extends Equatable {
  final DateTime? products;
  final DateTime? images;
  final DateTime? users;
  final DateTime? enterprise;
  final String? enterpriseName;

  const LastImportEntity({
    required this.products,
    required this.images,
    required this.users,
    required this.enterprise,
    required this.enterpriseName,
  });

  @override
  List<Object?> get props => [
        products,
        images,
        users,
        enterprise,
        enterpriseName,
      ];
}
