import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages.dart';

List<Widget> allButtons(BuildContext context) {
  HomePresenter homePresenter = Provider.of(context, listen: false);

  return [
    ProductsSchedulesButton(),
    UpdateMenuButton(),
    CancelProductsOrRemoveServiceChargeButton(),
    TableConfigurationsButton(),
    SendAllProductsToAnotherTableButton(),
    DoLogoutButton(),
    LiberateOrBlockTableButton(),
    if (!homePresenter.isGeneratingVersionToRede &&
        !homePresenter.isGeneratingVersionToGetNet)
      ReserveTableButton(),
  ];
}
