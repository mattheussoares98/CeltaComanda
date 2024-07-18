import 'package:clean_celta_mobile/data/models/models.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteLoadExpansibleGroupsFromProductsComplete
    implements LoadExpansibleGroupsFromProductsComplete {
  final HttpClient httpAdapter;

  RemoteLoadExpansibleGroupsFromProductsComplete({required this.httpAdapter});

  @override
  Future<List<ExpansibleGroupFromProductCompleteEntity>> load(
    List<int> productPackingInternalCodesOnErp,
  ) async {
    try {
      final response = await httpAdapter.request(
          url:
              "${EnterpriseDataBuilder.enterpriseDataEntity!.url!}/api/APIGroups/FindFromProductsComplete",
          method: "post",
          body: {
            "ExpansibleGroupType": 22, //tipo do grupo expansível (opcional)
            "ProductPackingInternalCodesOnErp":
                productPackingInternalCodesOnErp,
          });
      if (response == null) {
        throw Error();
      }

      return response.map<ExpansibleGroupFromProductCompleteEntity>((element) {
        return ExpansibleGroupFromProductsCompleteModel.fromJson(element)
            .toEntity();
      }).toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
