import '../../../domain/entities/entities.dart';
import '../../infra/helpers/helperts.dart';
import '../http/http.dart';

class RemoteCrossIdModel {
  final String crossId;

  RemoteCrossIdModel({required this.crossId});

  factory RemoteCrossIdModel.fromJson(Map json) {
    if (!json.containsKey(CacheKeys.crossId.name)) {
      throw HttpError.invalidData;
    }
    return RemoteCrossIdModel(crossId: json[CacheKeys.crossId.name]);
  }

  CrossIdEntity toEntity() => CrossIdEntity(crossId: crossId);
}
