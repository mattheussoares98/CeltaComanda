import 'package:equatable/equatable.dart';

enum SoapResponseType {
  success,
  error,
}

class SoapResponse extends Equatable {
  final SoapResponseType responseType;
  final String response;

  const SoapResponse({
    required this.response,
    required this.responseType,
  });

  @override
  List<Object?> get props => [response, responseType];
}
