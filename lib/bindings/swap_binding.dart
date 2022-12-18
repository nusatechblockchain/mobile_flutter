import 'package:naga_exchange/controllers/swap_controller.dart';
import 'package:naga_exchange/controllers/wallet_controller.dart';
import 'package:get/get.dart';

class SwapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletController());
    Get.lazyPut(() => SwapController());
  }
}
