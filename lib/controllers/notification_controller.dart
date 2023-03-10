import 'package:naga_exchange/controllers/error_controller.dart';
import 'package:naga_exchange/models/notification_response.dart';
import 'package:naga_exchange/repository/notification_repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationController extends GetxController {
  var isLoading = true.obs;
  var showReload = false.obs;
  var notificationList = <NotificationResponse>[].obs;
  ErrorController errorController = new ErrorController();

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  void fetchNotifications() async {
    NotificationRepository _notificationRepository =
        new NotificationRepository();
    try {
      showReload(false);
      isLoading(true);
      var notifications = await _notificationRepository.fetchNotifications();
      notifications.sort((a, b) {
        String adate = DateFormat('yyyy-MM-dd hh:mm:ss').format(a.createdAt);
        String bdate = DateFormat('yyyy-MM-dd hh:mm:ss').format(b.createdAt);
        return -adate.compareTo(bdate);
      });
      notificationList.assignAll(notifications);
      isLoading(false);
    } catch (error) {
      showReload(true);
      isLoading(false);
      print(error);
      errorController.handleError(error);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
