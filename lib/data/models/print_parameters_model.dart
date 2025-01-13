import 'package:equatable/equatable.dart';

class PrintParametersModel extends Equatable {
  final bool alignCenter;
  final bool bold;
  final String text;
  final int width;

  const PrintParametersModel({
    required this.alignCenter,
    required this.bold,
    required this.text,
    required this.width,
  });

  @override
  List<Object?> get props => [alignCenter, bold, text, width];
}
