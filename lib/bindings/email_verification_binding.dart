import 'package:naga_exchange/controllers/RegisterController.dart';
import 'package:get/get.dart';

class EmailVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}
