// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class TelephoneEntity extends Equatable {
  final String AreaCode;
  final String PhoneNumber;

  const TelephoneEntity({
    required this.AreaCode,
    required this.PhoneNumber,
  });

  @override
  List<Object?> get props => [
        AreaCode,
        PhoneNumber,
      ];
}
