import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';
import '../../models/models.dart';

class RemoteConcFinishSaleRequest
    with ErrorHandling
    implements ConcFinishSaleRequest {
  final HttpClient httpAdapter;

  RemoteConcFinishSaleRequest({required this.httpAdapter});

  @override
  Future<void> finish({
    required int pdvNumber,
    required int commandNumber,
    required List<ConcentratorFinalizationModel>? finalizations,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      String pdvNumberWithThreeNumbers = pdvNumber.toString().padLeft(3, "0");
      String commandNumberWithThreeNumbers =
          commandNumber.toString().padLeft(3, "0");

      List<Map<String, dynamic>?> body = [];

      if (finalizations != null) {
        body = finalizations.map((e) => e.toJson()).toList();
      }

      final response = await httpAdapter.request(
        url:
            '${EnterpriseBuilder.entity!.concentradorUrl!}/api/APISaleRequest/Finish?enterpriseId=${EnterpriseBuilder.entity!.enterpriseId}&pdvnumber=$pdvNumberWithThreeNumbers&personalizedCode=$commandNumberWithThreeNumbers',
        method: "put",
        headers: headers,
        body: body.isEmpty ? null : body,
      );
      if (response == null) {
        throw Error();
      }
    } catch (e) {
      treatError(e);
    }
  }
}
