import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';

CartPage makeCartPage(
        PageController? pageController, bool? isFixedCommandNumber) =>
    CartPage(
      pageController: pageController,
      isFixedCommandNumber: isFixedCommandNumber,
    );
