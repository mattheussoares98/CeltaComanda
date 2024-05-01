// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class TicketIsPermittedModel {
  final int TicketAccessControlId;
  final String Number;
  final String Barcode;
  final dynamic RefIdNumber;
  final dynamic DateHourLastRelease;

  TicketIsPermittedModel({
    required this.TicketAccessControlId,
    required this.Number,
    required this.Barcode,
    this.RefIdNumber,
    this.DateHourLastRelease,
  });

  factory TicketIsPermittedModel.fromJson(Map json) {
    if (!json.keys
        .toSet()
        .containsAll(['TicketAccessControlId', 'Number', 'Barcode'])) {
      throw Exception();
    }
    return TicketIsPermittedModel(
      TicketAccessControlId: json["TicketAccessControlId"],
      Number: json["Number"],
      Barcode: json["Barcode"],
      DateHourLastRelease: json["DateHourLastRelease"],
      RefIdNumber: json["RefIdNumber"],
    );
  }

  factory TicketIsPermittedModel.fromEntity(TicketIsPermittedEntity entity) =>
      TicketIsPermittedModel(
        TicketAccessControlId: entity.TicketAccessControlId,
        Number: entity.Number,
        Barcode: entity.Barcode,
        DateHourLastRelease: entity.DateHourLastRelease,
        RefIdNumber: entity.RefIdNumber,
      );

  TicketIsPermittedEntity toEntity() => TicketIsPermittedEntity(
        TicketAccessControlId: TicketAccessControlId,
        Number: Number,
        Barcode: Barcode,
        DateHourLastRelease: DateHourLastRelease,
        RefIdNumber: RefIdNumber,
      );

  Map<String, dynamic> toJson() => {
        "TicketAccessControlId": TicketAccessControlId,
        "Number": Number,
        "Barcode": Barcode,
        "DateHourLastRelease": DateHourLastRelease,
        "RefIdNumber": RefIdNumber,
      };
}
