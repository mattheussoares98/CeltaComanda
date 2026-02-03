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
        concentratorUrl: "http://cloud.celtaware.com.br:42021",
        enteprisePersonalizedCode: "02",
      );
      //local configurations for tests
    }

    String settingsUrl = '${Uri.base.removeFragment()}settings.txt';

    final response = await httpAdapter.request(
      url: settingsUrl,
      method: "get",
    );

    return WebLocalSettingsModel.fromJson(response).toEntity();
  }
}
