import 'package:equatable/equatable.dart';

class ParameterModel extends Equatable {
  final String name;
  final bool enabled;

  const ParameterModel({
    required this.name,
    required this.enabled,
  });

  @override
  List<Object?> get props => [name, enabled];

  factory ParameterModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'name',
      'enabled',
    ])) {
      throw Exception();
    }
    return ParameterModel(
      name: json["name"],
      enabled: json["enabled"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "enabled": enabled,
      };
}
