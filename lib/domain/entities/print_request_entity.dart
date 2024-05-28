import 'package:equatable/equatable.dart';

class PrintRequestEntity extends Equatable {
  final List<String> dates;
  final int timesUsed;

  const PrintRequestEntity({
    required this.dates,
    required this.timesUsed,
  });

  @override
  List get props => [dates, timesUsed];
}
