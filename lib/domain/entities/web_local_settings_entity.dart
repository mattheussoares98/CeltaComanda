class WebLocalSettingsEntity {
  final int? enterpriseId;
  final int concentratorPort;
  final int navsPort;
  final String defaultUrl;
  final String? enteprisePersonalizedCode;

  WebLocalSettingsEntity({
    required this.enterpriseId,
    required this.concentratorPort,
    required this.navsPort,
    required this.defaultUrl,
    required this.enteprisePersonalizedCode,
  });
}
