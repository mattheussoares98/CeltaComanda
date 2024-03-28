import '../../../domain/entities/entities.dart';
import '../http/http.dart';

class RemoteCrossIdModel {
  final String crossId;

  RemoteCrossIdModel({ required this.crossId });

  factory RemoteCrossIdModel.fromJson(Map json) {
    if (!json.containsKey('crossId')) {
      throw HttpError.invalidData;
    }
    return RemoteCrossIdModel(crossId: json['crossId']);
  }

  CrossIdEntity toEntity() => CrossIdEntity(crossId: crossId);
}