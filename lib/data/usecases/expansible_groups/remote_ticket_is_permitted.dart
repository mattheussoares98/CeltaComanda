import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteTicketIsPermitted implements TicketIsPermitted {
  final HttpClient httpAdapter;

  RemoteTicketIsPermitted({required this.httpAdapter});
  @override
  Future<dynamic> verify({
    required String url,
    required String commandNumber,
  }) async {
    try {
      final response = await httpAdapter.request(
        url:
            "$url/api/APISaleRequest/TicketIsPermited?_personalizedCode=$commandNumber",
        method: "get",
      );
      if (response == null) {
        throw Error();
      }
    } catch (error) {
      throw DomainError.commandNotAvailable;
    }
  }
}
