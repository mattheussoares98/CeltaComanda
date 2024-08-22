import '../../../domain/helpers/helpers.dart';
import '../../../infra/http/http.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';

class RemoteIsValidDatetime implements IsValidDatetime {
  final HttpAdapter httpAdapter;

  RemoteIsValidDatetime({required this.httpAdapter});

  @override
  Future<bool> verify({required String commandNumber}) async {
    try {
      final isValid = await httpAdapter.request(
        url:
            "${EnterpriseDataBuilder.enterpriseDataEntity!.url!}/api/APITicketAC/IsValidDateTime?ticketNumber=$commandNumber",
        method: "get",
      );

      if (isValid == null) {
        throw Error();
      }

      return isValid == true;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
