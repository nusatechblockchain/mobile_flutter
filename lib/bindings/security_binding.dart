import 'package:naga_exchange/controllers/HomeController.dart';
import 'package:get/get.dart';

class SecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
