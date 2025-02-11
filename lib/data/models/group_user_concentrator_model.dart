import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class GroupUserConcentratorModel extends Equatable {
  final int? GroupId;
  final String? Name;
  final double? PercMaxLimitDiscount;
  final bool? AllowDiscountOnTotal;
  final bool? AllowDiscountOnItem;
  final bool? IsInternal;

  const GroupUserConcentratorModel({
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

  factory GroupUserConcentratorModel.fromJson(Map json) =>
      GroupUserConcentratorModel(
        GroupId: json["GroupId"],
        Name: json["Name"],
        PercMaxLimitDiscount: json["PercMaxLimitDiscount"],
        AllowDiscountOnTotal: json["AllowDiscountOnTotal"],
        AllowDiscountOnItem: json["AllowDiscountOnItem"],
        IsInternal: json["IsInternal"],
      );

  Map<String, dynamic> toJson() => {
        'GroupId': GroupId,
        'Name': Name,
        'PercMaxLimitDiscount': PercMaxLimitDiscount,
        'AllowDiscountOnTotal': AllowDiscountOnTotal,
        'AllowDiscountOnItem': AllowDiscountOnItem,
        'IsInternal': IsInternal,
      };

  factory GroupUserConcentratorModel.fromEntity(
    GroupUserConcentratorEntity entity,
  ) =>
      GroupUserConcentratorModel(
        GroupId: entity.GroupId,
        Name: entity.Name,
        PercMaxLimitDiscount: entity.PercMaxLimitDiscount,
        AllowDiscountOnTotal: entity.AllowDiscountOnTotal,
        AllowDiscountOnItem: entity.AllowDiscountOnItem,
        IsInternal: entity.IsInternal,
      );

  GroupUserConcentratorEntity toEntity() => GroupUserConcentratorEntity(
        GroupId: GroupId,
        Name: Name,
        PercMaxLimitDiscount: PercMaxLimitDiscount,
        AllowDiscountOnTotal: AllowDiscountOnTotal,
        AllowDiscountOnItem: AllowDiscountOnItem,
        IsInternal: IsInternal,
      );
}
