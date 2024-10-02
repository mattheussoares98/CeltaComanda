import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteFinishSaleRequestConcentrador
    implements FinishSaleRequestConcentrador {
  final HttpClient httpAdapter;

  RemoteFinishSaleRequestConcentrador({required this.httpAdapter});

  @override
  Future<void> finish({
    required int pdvNumber,
    required int commandNumber,
    required int? finalizationIdentification,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      String pdvNumberWithThreeNumbers = pdvNumber.toString().padLeft(3, "0");
      String commandNumberWithThreeNumbers =
          commandNumber.toString().padLeft(3, "0");

      final response = await httpAdapter.request(
        url:
            '${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl!}/api/APISaleRequest/Finish?enterpriseId=${EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId}&pdvnumber=$pdvNumberWithThreeNumbers&personalizedCode=$commandNumberWithThreeNumbers&finalizationIdentification=$finalizationIdentification',
        method: "put",
        headers: headers,
      );
      if (response == null) {
        throw Error();
      }
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
