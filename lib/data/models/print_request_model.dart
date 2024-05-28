import '../../domain/entities/entities.dart';

class PrintRequestModel {
  final List<String> dates;
  final int timesUsed;

  PrintRequestModel({
    required this.dates,
    required this.timesUsed,
  });

  factory PrintRequestModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'dates',
      'timesUsed',
    ])) {
      throw Exception();
    }
    return PrintRequestModel(
      dates: json['dates'],
      timesUsed: json["timesUsed"],
    );
  }

  factory PrintRequestModel.fromEntity(PrintRequestEntity entity) =>
      PrintRequestModel(
        timesUsed: entity.timesUsed,
        dates: entity.dates,
      );

  PrintRequestEntity toEntity() => PrintRequestEntity(
        dates: dates,
        timesUsed: timesUsed,
      );

  Map<String, dynamic> toJson() => {
        'dates': dates,
        'timesUsed': timesUsed,
      };
}
