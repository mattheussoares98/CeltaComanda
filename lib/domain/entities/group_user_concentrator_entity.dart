import 'package:equatable/equatable.dart';

class GroupUserConcentratorEntity extends Equatable {
  final int? GroupId;
  final String? Name;
  final double? PercMaxLimitDiscount;
  final bool? AllowDiscountOnTotal;
  final bool? AllowDiscountOnItem;
  final bool? IsInternal;

  const GroupUserConcentratorEntity({
    required this.GroupId,
    required this.Name,
    required this.PercMaxLimitDiscount,
    required this.AllowDiscountOnTotal,
    required this.AllowDiscountOnItem,
    required this.IsInternal,
  });

  @override
  List<Object?> get props => [
        GroupId,
        Name,
        PercMaxLimitDiscount,
        AllowDiscountOnTotal,
        AllowDiscountOnItem,
        IsInternal,
      ];
}
