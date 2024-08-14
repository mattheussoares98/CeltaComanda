import 'package:get/get.dart';

mixin ComboxIsValidManager on GetxController {
  final _comboxIsValid = false.obs;
  Stream<bool> get comboxIsValidStream => _comboxIsValid.stream;
  set comboxIsValid(bool value) => _comboxIsValid.value = value;
}
