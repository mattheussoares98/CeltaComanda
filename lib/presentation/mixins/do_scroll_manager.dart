import 'package:get/get.dart';

mixin DoScrollManager on GetxController {
  final _doScroll = false.obs;
  Stream<bool> get doScrollStream => _doScroll.stream;
  set doScroll(bool _) {
    Future.delayed(const Duration(milliseconds: 50), () {
      _doScroll.subject.add(false);
      Future.delayed(const Duration(milliseconds: 50), () {
        _doScroll.subject.add(true);
      });
    });
  }
}
