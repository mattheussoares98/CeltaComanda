import '../../entities/entities.dart';

abstract class TicketIsPermitted {
  Future<TicketIsPermittedEntity?> verify({required String url, required String commandNumber});
}