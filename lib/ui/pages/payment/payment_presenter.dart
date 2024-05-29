import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

abstract class PaymentPresenter with ChangeNotifier implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
}
