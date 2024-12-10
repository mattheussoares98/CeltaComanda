import 'package:equatable/equatable.dart';

class ParameterModel extends Equatable {
  final String name;
  final bool enabled;
  final ParameterKey key;

  const ParameterModel({
    required this.name,
    required this.enabled,
    required this.key,
  });

  @override
  List<Object?> get props => [name, enabled, key];

  factory ParameterModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'name',
      'enabled',
      'key',
    ])) {
      throw Exception();
    }
    return ParameterModel(
      name: json["name"],
      enabled: json["enabled"],
      key: ParameterKey.values.firstWhere((e) => e.name == json["key"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "enabled": enabled,
        "key": key.name,
      };
}

enum ParameterKey { enableSearchProducts }
