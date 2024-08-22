import '../../../main/builders/builders.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteOpenOrBlockade implements OpenOrBlockade {
  final HttpClient httpAdapter;

  RemoteOpenOrBlockade({required this.httpAdapter});
  @override
  Future<bool> blockOrLiberate({
    required String commandNumber,
    required bool block,
  }) async {
    try {
      final ticketIsPermitted = await httpAdapter.request(
        url:
            "${EnterpriseDataBuilder.enterpriseDataEntity!.url!}/api/APITicketAC/OpenOrBlockade?_personalizedCode=$commandNumber&isOpen=$block",
        method: "post",
      );

      if (ticketIsPermitted == null) {
        throw Error();
      }

      return ticketIsPermitted == true;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
