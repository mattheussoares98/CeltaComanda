import 'package:clean_celta_mobile/data/models/models.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteLoadExpansibleGroupsByProductsCodes
    implements LoadExpansibleGroupsByProductsCodes {
  final HttpClient httpAdapter;

  RemoteLoadExpansibleGroupsByProductsCodes({required this.httpAdapter});

  @override
  Future<List<ExpansibleGroupFromProductsCompleteEntity>> load({
    required List<int> productsPackingInternalCodesOnErp,
    required int expansibleGroupType,
  }) async {
    try {
      final response = await httpAdapter.request(
          url:
              "${EnterpriseBuilder.entity!.url!}/api/APIGroups/FindFromProductsComplete",
          method: "post",
          body: {
            "ExpansibleGroupType":
                expansibleGroupType, //tipo do grupo expansível (opcional no BS)
            "ProductPackingInternalCodesOnErp":
                productsPackingInternalCodesOnErp,
          });
      if (response == null) {
        throw Error();
      }

      return response.map<ExpansibleGroupFromProductsCompleteEntity>((element) {
        return ExpansibleGroupFromProductsCompleteModel.fromJson(element)
            .toEntity();
      }).toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
