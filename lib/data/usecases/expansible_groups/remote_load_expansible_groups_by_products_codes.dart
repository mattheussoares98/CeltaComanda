import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';

class RemoteLoadExpansibleGroupsByProductsCodes
    with ErrorHandling
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
    } catch (e) {
      treatError(e);
    }
  }
}
