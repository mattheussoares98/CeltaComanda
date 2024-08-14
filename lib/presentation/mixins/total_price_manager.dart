import 'package:get/get.dart';

mixin TotalPriceManager on GetxController {
  final _totalPrice = Rx<double>(0);
  Stream<double> get totalPriceStream => _totalPrice.stream;
  set totalPrice(double newValue) => _totalPrice.subject.add(newValue);
}
