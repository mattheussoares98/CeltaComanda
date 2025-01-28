class ExportChargingModel {
  final DateTime lastUpdateImages;
  final DateTime lastUpdateProducts;

  const ExportChargingModel({
    required this.lastUpdateImages,
    required this.lastUpdateProducts,
  });

  factory ExportChargingModel.fromJson(Map json) {
    return ExportChargingModel(
      lastUpdateImages: DateTime.parse(json['lastUpdateImages']),
      lastUpdateProducts: DateTime.parse(json['lastUpdateProducts']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastUpdateImages': lastUpdateImages.toIso8601String(),
      'lastUpdateProducts': lastUpdateProducts.toIso8601String(),
    };
  }
}
