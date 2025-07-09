import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages.dart';

List<Widget> allButtons(BuildContext context) {
  HomePresenter homePresenter = Provider.of(context, listen: false);

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
    if (!homePresenter.isGeneratingVersionToRede &&
        !homePresenter.isGeneratingVersionToGetNet)
      const ReserveTableButton(),
    const SaleMovementButton()
  ];
}
