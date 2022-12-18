import 'package:get/get.dart';
import 'package:naga_exchange/models/user.dart';

class UserController extends GetxController {
  var user = new User().obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
