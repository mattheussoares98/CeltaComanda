import 'package:clean_celta_mobile/data/http/http.dart';
import 'package:clean_celta_mobile/infra/helpers/helperts.dart';

import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {
  When mockRequestCall() => when(() => request(
      url: any(named: CacheKeys.url.name),
      method: any(named: 'method'),
      body: any(named: 'body'),
      headers: any(named: 'headers')));
  void mockRequest(dynamic data) =>
      mockRequestCall().thenAnswer((_) async => data);
  void mockRequestError(HttpError error) => mockRequestCall().thenThrow(error);
}
