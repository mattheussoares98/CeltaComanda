class ParametersModel {
  final String name;
  final bool enabled;

  ParametersModel({
    required this.name,
    required this.enabled,
  });

  factory ParametersModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'name',
      'enabled',
    ])) {
      throw Exception();
    }
    return ParametersModel(
      name: json["name"],
      enabled: json["enabled"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "enabled": enabled,
      };
}
