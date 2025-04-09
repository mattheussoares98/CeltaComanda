import 'package:get/get.dart';

mixin TotalProductsQuantityManager on GetxController {
  double _totalProductsQuantity = 1;
  double get totalProductsQuantity => _totalProductsQuantity;
  set totalProductsQuantity(double newValue) => _totalProductsQuantity = newValue;
}
