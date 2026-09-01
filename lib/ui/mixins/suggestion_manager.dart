import 'dart:async';

import 'package:flutter/material.dart';

import '../../main/builders/builders.dart';
import '../pages/home/components/show_suggestion_dialog.dart';
import '../pages/menus/menu_presenter.dart';
import '../pages/products/products_view_model.dart';

mixin SuggestionManager {
  StreamSubscription handleSuggestion(
    BuildContext context,
    Stream<ProductsViewModel?> stream,
    MenuPresenter menuPresenter,
  ) {
    final streamSubscription = stream.listen((product) {
      if (product != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showSuggestionDialog(
            NavigatorKey.key.currentState?.context ?? context,
            product,
            menuPresenter,
          );
        });
      }
    });

    return streamSubscription;
  }
}
