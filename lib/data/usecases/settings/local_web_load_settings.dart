import 'package:clean_celta_mobile/domain/entities/web_local_settings_entity.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/usecases/settings/settings.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class LocalWebLoadSettings implements WebLoadSettings {
  final HttpClient httpAdapter;
  LocalWebLoadSettings(this.httpAdapter);

  @override
  Future<WebLocalSettingsEntity> load() async {
    if (!kIsWeb) {
      return WebLocalSettingsEntity(
        url: EnterpriseBuilder.entity!.url,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId,
        isConsiderDelivered: false,
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
