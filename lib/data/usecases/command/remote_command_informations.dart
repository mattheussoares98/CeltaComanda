import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteCommandInformations implements CommandInformations {
  final HttpClient httpAdapter;

  RemoteCommandInformations({required this.httpAdapter});

  @override
  Future<bool> isValidDatetime({required String commandNumber}) async {
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

  @override
  Future<bool> openOrBlockade({
    required String commandNumber,
    required bool isOpen,
  }) async {
    try {
      final ticketIsPermitted = await httpAdapter.request(
        url:
            "${EnterpriseDataBuilder.enterpriseDataEntity!.url!}/api/APITicketAC/OpenOrBlockade?_personalizedCode=$commandNumber&isOpen=$isOpen",
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

  @override
  Future<TicketIsPermittedEntity?> ticketIsPermitted({
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
