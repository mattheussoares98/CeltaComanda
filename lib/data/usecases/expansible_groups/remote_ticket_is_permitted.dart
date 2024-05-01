import 'package:clean_celta_mobile/data/models/ticket_is_permitted_model.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteTicketIsPermitted implements TicketIsPermitted {
  final HttpClient httpAdapter;

  RemoteTicketIsPermitted({required this.httpAdapter});
  @override
  Future<TicketIsPermittedEntity?> verify({
    required String url,
    required String commandNumber,
  }) async {
    try {
      final ticketIsPermitted = await httpAdapter.request(
        url:
            "$url/api/APISaleRequest/TicketIsPermited?_personalizedCode=$commandNumber",
        method: "get",
      );

      if (ticketIsPermitted == null) {
        throw Error();
      }

      return TicketIsPermittedModel.fromJson(ticketIsPermitted).toEntity();
    } catch (error) {
      throw DomainError.commandNotAvailable;
    }
  }
}
