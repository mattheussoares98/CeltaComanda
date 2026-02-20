import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/settings/settings.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class LocalWebLoadSettings implements WebLoadSettings {
  final HttpClient httpAdapter;
  LocalWebLoadSettings(this.httpAdapter);

  @override
  Future<WebLocalSettingsEntity> load() async {
    if (kDebugMode) {
      return WebLocalSettingsEntity(
        enterpriseId: 2,
        defaultUrl: "http://localhost",
        concentratorPort: 64286,
        navsPort: 10966,
        enteprisePersonalizedCode: "02",
      );
      //local configurations for tests
    }

    final baseUri = Uri.base;

    String settingsUrl = '${baseUri.removeFragment()}settings.txt';

    final response = await httpAdapter.request(
      url: settingsUrl,
      method: "get",
    );

    final urlWithoutPort = Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      path: baseUri.path,
    ).removeFragment().toString();
    final cleanedUrl = urlWithoutPort.endsWith('/')
        ? urlWithoutPort.substring(0, urlWithoutPort.length - 1)
        : urlWithoutPort;

    return WebLocalSettingsModel.fromJson(response, cleanedUrl).toEntity();
  }
}
