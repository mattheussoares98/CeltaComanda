import 'package:clean_celta_mobile/data/models/expansible_groups_model.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';

import '../../../../data/http/http.dart';
import '../../../../domain/entities/entities.dart';
import '../../../../domain/helpers/helpers.dart';
import '../../../../domain/usecases/usecases.dart';

class RemoteLoadExpansibleGroups implements LoadExpansibleGroups {
  final HttpClient httpAdapter;

  RemoteLoadExpansibleGroups({required this.httpAdapter});

  @override
  Future<List<ExpansibleGroupEntity>?> load() async {
    try {
      final response = await httpAdapter.request(
        url:
            "${EnterpriseDataBuilder.enterpriseDataEntity!.url!}/api/APIGroups/GetAll?_enterpriseId=${EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId}",
        method: "get",
      );
      if (response == null) {
        throw Error();
      }

      return response.map<ExpansibleGroupEntity>((element) {
        return ExpansibleGroupsModel.fromJson(element).toEntity();
      }).toList();
      
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
