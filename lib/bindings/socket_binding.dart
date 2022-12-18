import 'package:naga_exchange/controllers/web_socket_controller.dart';
import 'package:get/get.dart';

class SocketBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WebSocketController>(WebSocketController());
  }
}
