import '../../../ui/helpers/helpers.dart';
import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../ui/pages/pages.dart';

class PrintedModel {
  final List<PrintedProductsEntity> Products;
  final String PersonalizedCode;
  final String DateOfCreation;
  final String DateHourOfCreation;
  final String FlagStatus;
  final int EnterpriseId;
  final dynamic RequestType;
  final bool IsCancelled;
  final bool IsUsing;
  final double TotalLiquid;
  final int Peoples;
  final int SaleRequestId;
  final int FlagOrigin;
  final int DeliveryControl;
  final String? Comments;
  final int? IncrementType;
  final double? IncrementValue;
  final int? CovenantCode;
  final int? CustomerCode;
  final int? SellerCode;

  PrintedModel({
    required this.Products,
    required this.PersonalizedCode,
    required this.DateOfCreation,
    required this.DateHourOfCreation,
    required this.FlagStatus,
    required this.EnterpriseId,
    required this.RequestType,
    required this.IsCancelled,
    required this.IsUsing,
    required this.TotalLiquid,
    required this.Peoples,
    required this.SaleRequestId,
    required this.FlagOrigin,
    required this.DeliveryControl,
    required this.Comments,
    required this.IncrementType,
    required this.IncrementValue,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.SellerCode,
  });

  factory PrintedModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      "Products",
      "PersonalizedCode",
      "EnterpriseId",
      "TotalLiquid",
      "SaleRequestId",
    ])) {
      throw Exception();
    }
    return PrintedModel(
      Products: (json["Products"] as List)
          .map((e) => PrintedProductsEntity(
                Product: ProductModel.fromJson(e["Product"]).toEntity(),
                SaleRequestProductId: e["SaleRequestProductId"],
                ProductPriceLookUpCode: e["ProductPriceLookUpCode"],
                Value: e["Value"],
                Quantity: e["Quantity"],
                QuantityString: e["QuantityString"],
                Comments: e["Comments"],
                UserId: e["UserId"],
                DateHourOfCreation: e["DateHourOfCreation"],
                IsCancelled: e["IsCancelled"],
                IsDelivered: e["IsDelivered"],
                IsPrinted: e["IsPrinted"],
                ProductionStatus: e["ProductionStatus"],
                TotalLiquid: e["TotalLiquid"],
                ProductInternalCodeOnErp: e["ProductInternalCodeOnErp"],
                SaleRequestId: e["SaleRequestId"],
                ProductIsFatherComposition: e["ProductIsFatherComposition"],
                childs: e["childs"] ?? [],
                SaleRequestProductIdOfFather: e["SaleRequestProductIdOfFather"],
                SaleMovementProductCompositionId: e["SaleMovementProductCompositionId"],
                UserIdOfCancellation: e["UserIdOfCancellation"],
              ))
          .toList(),
      PersonalizedCode: json["PersonalizedCode"],
      DateOfCreation: json["DateOfCreation"],
      DateHourOfCreation: json["DateHourOfCreation"],
      FlagStatus: json["FlagStatus"],
      EnterpriseId: json["EnterpriseId"],
      RequestType: json["RequestType"],
      IsCancelled: json["IsCancelled"],
      IsUsing: false,
      TotalLiquid: json["TotalLiquid"],
      Peoples: json["Peoples"],
      SaleRequestId: json["SaleRequestId"],
      FlagOrigin: json["FlagOrigin"],
      DeliveryControl: json["DeliveryControl"],
      Comments: json["Comments"],
      IncrementType: json["IncrementType"],
      IncrementValue: json["IncrementValue"],
      CovenantCode: json["CovenantCode"],
      CustomerCode: json["CustomerCode"],
      SellerCode: json["SellerCode"],
    );
  }

  factory PrintedModel.fromEntity(PrintedEntity entity) => PrintedModel(
        Products: entity.Products,
        PersonalizedCode: entity.PersonalizedCode,
        DateOfCreation: entity.DateOfCreation,
        DateHourOfCreation: entity.DateHourOfCreation,
        FlagStatus: entity.FlagStatus,
        EnterpriseId: entity.EnterpriseId,
        RequestType: entity.RequestType,
        IsCancelled: entity.IsCancelled,
        IsUsing: entity.IsUsing,
        TotalLiquid: entity.TotalLiquid,
        Peoples: entity.Peoples,
        SaleRequestId: entity.SaleRequestId,
        FlagOrigin: entity.FlagOrigin,
        DeliveryControl: entity.DeliveryControl,
        Comments: entity.Comments,
        IncrementType: entity.IncrementType,
        IncrementValue: entity.IncrementValue,
        CovenantCode: entity.CovenantCode,
        CustomerCode: entity.CustomerCode,
        SellerCode: entity.SellerCode,
      );

  PrintedEntity toEntity() => PrintedEntity(
        Products: Products,
        PersonalizedCode: PersonalizedCode,
        DateOfCreation: DateOfCreation,
        DateHourOfCreation: DateHourOfCreation,
        FlagStatus: FlagStatus,
        Comments: Comments,
        EnterpriseId: EnterpriseId,
        RequestType: RequestType,
        IsCancelled: IsCancelled,
        IsUsing: IsUsing,
        TotalLiquid: TotalLiquid,
        Peoples: Peoples,
        SaleRequestId: SaleRequestId,
        FlagOrigin: FlagOrigin,
        DeliveryControl: DeliveryControl,
        IncrementType: IncrementType,
        IncrementValue: IncrementValue,
        CovenantCode: CovenantCode,
        CustomerCode: CustomerCode,
        SellerCode: SellerCode,
      );

  Map<String, dynamic> toJson() => {
        "Products": Products,
        "PersonalizedCode": PersonalizedCode,
        "DateOfCreation": DateOfCreation,
        "DateHourOfCreation": DateHourOfCreation,
        "FlagStatus": FlagStatus,
        "Comments": Comments,
        "EnterpriseId": EnterpriseId,
        "RequestType": RequestType,
        "IsCancelled": IsCancelled,
        "IsUsing": IsUsing,
        "TotalLiquid": TotalLiquid,
        "Peoples": Peoples,
        "SaleRequestId": SaleRequestId,
        "FlagOrigin": FlagOrigin,
        "DeliveryControl": DeliveryControl,
        "IncrementType": IncrementType,
        "IncrementValue": IncrementValue,
        "CovenantCode": CovenantCode,
        "CustomerCode": CustomerCode,
        "SellerCode": SellerCode,
      };

  factory PrintedModel.fromViewModel(PrintedViewModel viewModel) =>
      PrintedModel(
        Products: viewModel.Products.map((e) => e.toEntity()).toList(),
        PersonalizedCode: viewModel.PersonalizedCode,
        DateOfCreation: viewModel.DateOfCreation,
        DateHourOfCreation: viewModel.DateHourOfCreation,
        FlagStatus: viewModel.FlagStatus,
        EnterpriseId: viewModel.EnterpriseId.toInt(),
        RequestType: viewModel.RequestType,
        IsCancelled: viewModel.IsCancelled == "true",
        IsUsing: viewModel.IsUsing == "true",
        TotalLiquid: viewModel.TotalLiquid.toDouble(),
        Peoples: viewModel.Peoples.toInt(),
        SaleRequestId: viewModel.SaleRequestId.toInt(),
        FlagOrigin: viewModel.FlagOrigin.toInt(),
        DeliveryControl: viewModel.DeliveryControl.toInt(),
        Comments: viewModel.Comments,
        IncrementType: viewModel.IncrementType.toInt(),
        IncrementValue: viewModel.IncrementValue.toDouble(),
        CovenantCode: viewModel.CovenantCode?.toInt(),
        CustomerCode: viewModel.CustomerCode?.toInt(),
        SellerCode: viewModel.SellerCode?.toInt(),
      );
}
