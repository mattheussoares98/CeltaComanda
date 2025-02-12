import 'package:clean_celta_mobile/domain/entities/group_permission_concentrator/group_permission_concentrator_entity.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../infra/http/http.dart';
import '../../../main/builders/builders.dart';
import '../../models/models.dart';

class ConcentratorLoadGroupPermissions implements LoadGroupPermissions {
  final HttpAdapter httpAdapter;
  ConcentratorLoadGroupPermissions({required this.httpAdapter});

  @override
  Future<List<GroupPermissionConcentratorEntity>> getAll() async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseBuilder.entity?.concentradorUrl;
      final response = await httpAdapter.request(
        url: '$url/api/APIGroupPermissions/GetAll',
        method: "put",
        headers: headers,
      );
      if (response == null) {
        throw Exception();
      } else {
        return (response as List)
            .map((e) => GroupPermissionConcentratorModel.fromJson(e).toEntity())
            .toList()
            .where(
          (e) {
            final permissionName = e.Permission?.Name?.toLowerCase();

            return permissionName == "Agendamento de produtos".toLowerCase() ||
                permissionName == "Atualizar menu".toLowerCase() ||
                permissionName == "Cancelar itens".toLowerCase() ||
                permissionName == "Configurações da Mesa".toLowerCase() ||
                permissionName == "Fazer logout".toLowerCase() ||
                permissionName == "Fechar mesa".toLowerCase() ||
                permissionName == "Liberar/Bloquear mesa".toLowerCase() ||
                permissionName == "Parâmetros".toLowerCase() ||
                permissionName == "Reservar mesa".toLowerCase() ||
                permissionName ==
                    "Trocar produtos entre comandas".toLowerCase();
          },
        ).toList();
      }
    } catch (e) {
      throw Exception();
    }
  }
}
