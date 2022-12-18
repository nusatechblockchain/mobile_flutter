import 'package:naga_exchange/controllers/wallet_controller.dart';
import 'package:get/get.dart';

class WalletSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletController());
  }
}
