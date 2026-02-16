import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class PrintedEntity extends Equatable {
  final List<PrintedProductsEntity> Products;
  final String? PersonalizedCode;
  final String? DateOfCreation;
  final String? DateHourOfCreation;
  final String? FlagStatus;
  final int? EnterpriseId;
  final dynamic RequestType;
  final bool? IsCancelled;
  final bool? IsUsing;
  final double? TotalLiquid;
  final int? Peoples;
  final int? SaleRequestId;
  final int? FlagOrigin;
  final int? DeliveryControl;
  final int? IncrementType;
  final double? IncrementValue;
  final int? CovenantCode;
  final int? CustomerCode;
  final int? SellerCode;
  final String? Comments;
  final String? PlaceId;

  const PrintedEntity({
    required this.Products,
    required this.PersonalizedCode,
    required this.DateOfCreation,
    required this.DateHourOfCreation,
    required this.FlagStatus,
    required this.Comments,
    required this.PlaceId,
    required this.EnterpriseId,
    required this.RequestType,
    required this.IsCancelled,
    required this.IsUsing,
    required this.TotalLiquid,
    required this.Peoples,
    required this.SaleRequestId,
    required this.FlagOrigin,
    required this.DeliveryControl,
    required this.IncrementType,
    required this.IncrementValue,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.SellerCode,
  });

  @override
  List<Object?> get props => [
        Products,
        PersonalizedCode,
        DateOfCreation,
        DateHourOfCreation,
        FlagStatus,
        Comments,
        PlaceId,
        EnterpriseId,
        RequestType,
        IsCancelled,
        IsUsing,
        TotalLiquid,
        Peoples,
        SaleRequestId,
        FlagOrigin,
        DeliveryControl,
        IncrementType,
        IncrementValue,
        CovenantCode,
        CustomerCode,
        SellerCode,
      ];

  PrintedEntity copyWith({
    List<PrintedProductsEntity>? Products,
    String? PersonalizedCode,
    String? DateOfCreation,
    String? DateHourOfCreation,
    String? FlagStatus,
    int? EnterpriseId,
    dynamic RequestType,
    bool? IsCancelled,
    bool? IsUsing,
    double? TotalLiquid,
    int? Peoples,
    int? SaleRequestId,
    int? FlagOrigin,
    int? DeliveryControl,
    int? IncrementType,
    double? IncrementValue,
    int? CovenantCode,
    int? CustomerCode,
    int? SellerCode,
  }) {
    return PrintedEntity(
      Products: Products ?? this.Products,
      PersonalizedCode: PersonalizedCode ?? this.PersonalizedCode,
      DateOfCreation: DateOfCreation ?? this.DateOfCreation,
      DateHourOfCreation: DateHourOfCreation ?? this.DateHourOfCreation,
      FlagStatus: FlagStatus ?? this.FlagStatus,
      EnterpriseId: EnterpriseId ?? this.EnterpriseId,
      RequestType: RequestType ?? this.RequestType,
      IsCancelled: IsCancelled ?? this.IsCancelled,
      IsUsing: IsUsing ?? this.IsUsing,
      TotalLiquid: TotalLiquid ?? this.TotalLiquid,
      Peoples: Peoples ?? this.Peoples,
      SaleRequestId: SaleRequestId ?? this.SaleRequestId,
      FlagOrigin: FlagOrigin ?? this.FlagOrigin,
      DeliveryControl: DeliveryControl ?? this.DeliveryControl,
      IncrementType: IncrementType ?? this.IncrementType,
      IncrementValue: IncrementValue ?? this.IncrementValue,
      CovenantCode: CovenantCode ?? this.CovenantCode,
      CustomerCode: CustomerCode ?? this.CustomerCode,
      SellerCode: SellerCode ?? this.SellerCode,
      Comments: Comments ?? this.Comments,
      PlaceId: PlaceId ?? this.PlaceId,
    );
  }
}
