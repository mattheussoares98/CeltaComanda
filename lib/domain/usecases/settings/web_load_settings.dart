import '../../entities/entities.dart';

abstract class WebLoadSettings {
  Future<WebLocalSettingsEntity> load();
}
