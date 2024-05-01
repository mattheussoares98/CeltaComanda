// ignore_for_file: non_constant_identifier_names

class TicketIsPermittedEntity {
  final int TicketAccessControlId;
  final String Number;
  final String Barcode;
  final dynamic RefIdNumber;
  final dynamic DateHourLastRelease;

  TicketIsPermittedEntity({
    required this.TicketAccessControlId,
    required this.Number,
    required this.Barcode,
    this.RefIdNumber,
    this.DateHourLastRelease,
  });
}
