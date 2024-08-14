import 'package:get/get.dart';

mixin TotalProductsQuantityManager on GetxController {
  int _totalProductsQuantity = 1;
  int get totalProductsQuantity => _totalProductsQuantity;
  set totalProductsQuantity(int newValue) => _totalProductsQuantity = newValue;
}
