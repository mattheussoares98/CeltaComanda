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
    if (!kIsWeb) {
      //local configurations for tests
      return WebLocalSettingsEntity(
        enterpriseId: 2,
        concentratorUrl: "http://192.168.15.4:9090",
        enteprisePersonalizedCode: "02",
      );
    }

    String settingsUrl = '${Uri.base.removeFragment()}settings.txt';

    final response = await httpAdapter.request(
      url: settingsUrl,
      method: "get",
    );

    return WebLocalSettingsModel.fromJson(response).toEntity();
  }
}
