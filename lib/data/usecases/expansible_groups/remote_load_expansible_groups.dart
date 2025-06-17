import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';

class RemoteLoadExpansibleGroups
    with ErrorHandling
    implements LoadExpansibleGroups {
  final HttpClient httpAdapter;

  RemoteLoadExpansibleGroups({required this.httpAdapter});

  @override
  Future<List<ExpansibleGroupEntity>?> load() async {
    try {
      final response = await httpAdapter.request(
        url:
            "${EnterpriseBuilder.entity!.url!}/api/APIGroups/GetAll?_enterpriseId=${EnterpriseBuilder.entity!.enterpriseId}",
        method: "get",
      );
      if (response == null) {
        throw Error();
      }

      return response.map<ExpansibleGroupEntity>((element) {
        return ExpansibleGroupsModel.fromJson(element).toEntity();
      }).toList();
    } catch (e) {
      treatError(e);
    }
  }
}
