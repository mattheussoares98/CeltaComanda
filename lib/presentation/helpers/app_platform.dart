enum AppPlatform {
  rede(true),
  getnet(true),
  cielo(true),
  microsoftStore(false),
  tablet(false),
  webSaleRequestDetails(false);

  final bool isPaymentPlatform;
  const AppPlatform(this.isPaymentPlatform);
}

// Automatically updated by the switcher script
AppPlatform activePlatform = AppPlatform.tablet;
