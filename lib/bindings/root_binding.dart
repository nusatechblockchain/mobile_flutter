import 'package:naga_exchange/controllers/HomeController.dart';
import 'package:naga_exchange/controllers/market_controller.dart';
import 'package:get/get.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<MarketController>(MarketController());
  }
}
