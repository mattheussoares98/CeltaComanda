import 'package:clean_celta_mobile/main/builders/builders.dart';

import '../../../ui/pages/insert_products/product_composition_view_model.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../domain/helpers/helpers.dart';
import '../../http/http_client.dart';
import '../../models/models.dart';

class RemoteGetProductComposition extends GetProductComposition {
  final HttpClient httpAdapter;

  RemoteGetProductComposition(this.httpAdapter);

  @override
  Future<List<ProductCompositionEntity>> getFathers({
    required int internalCodeOnErp,
  }) async {
    try {
      final response = await httpAdapter.request(
          url:
              "${EnterpriseBuilder.entity!.url!}/api/APIProduct/getproductcomposition?_enterpriseId=${EnterpriseBuilder.entity!.enterpriseId!}&_internalCodeOnERPCodeFather=$internalCodeOnErp",
          method: "get");

      if (response == null) {
        throw DomainError.unexpected;
      }

      List<ProductCompositionEntity> list = response
          .map<ProductCompositionEntity>(
              (element) => ProductCompositionModel.fromJson(element).toEntity())
          .toList();

      list.sort((a, b) => a.ChildName!.compareTo(b.ChildName!));

      return list;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<List<ProductCompositionEntity>> getChildsOfFather({
    required int internalCodeOnErp,
    required List<ProductCompositionEntity> fathers,
  }) async {
    try {
      List<ProductCompositionEntity> childs = [];

      for (var father in fathers) {
        final childrenOfFather = await getFathers(
          internalCodeOnErp: father.InternalCodeOnERPCodeChild!,
        );

        final fatherWithChildrens =
            ProductCompositionViewModel.fromEntityWithChilds(
          father,
          childrenOfFather,
        );

        childs.add(fatherWithChildrens.toEntity());
      }

      return childs;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
