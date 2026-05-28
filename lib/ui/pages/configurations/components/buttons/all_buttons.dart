import 'package:clean_celta_mobile/presentation/helpers/app_platform.dart';
import 'package:flutter/material.dart';

import '../../../pages.dart';

List<Widget> allButtons(BuildContext context) {
  return [
    const ProductsSchedulesButton(),
    // UpdateMenuButton(),
    const CancelProductsOrRemoveServiceChargeButton(),
    const TableConfigurationsButton(),
    // SendAllProductsToAnotherTableButton(),
    const SendProductsToAnotherTableButton(),
    const DoLogoutButton(),
    const CloseCommandButton(),
    const LiberateOrBlockTableButton(),
    const ParametersButton(),
    if (!activePlatform.isPaymentPlatform) const ReserveTableButton(),
    const SaleMovementButton()
  ];
}
