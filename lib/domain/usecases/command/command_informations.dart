import '../../entities/entities.dart';

abstract class CommandInformations {
  Future<bool> isValidDatetime({required String commandNumber});

  Future<TicketIsPermittedEntity?> ticketIsPermitted(
      {required String url, required String commandNumber});

  Future<bool> openOrBlockade({
    required String commandNumber,
    required bool isOpen,
  });
}
