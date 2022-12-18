import 'package:naga_exchange/controllers/swap_history_controller.dart';
import 'package:get/get.dart';

class SwapHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SwapHistoryController());
  }
}
