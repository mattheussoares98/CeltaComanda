enum SoapResponseType {
  success,
  error,
}

class SoapResponse {
  final SoapResponseType responseType;
  final String response;

  const SoapResponse({
    required this.response,
    required this.responseType,
  });
}
