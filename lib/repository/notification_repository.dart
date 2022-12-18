import 'dart:async';
import 'package:naga_exchange/models/notification_response.dart';
import 'package:naga_exchange/network/api_provider.dart';
import 'package:naga_exchange/network/request_headers.dart';

class NotificationRepository {
  ApiProvider apiProvider;

  Future<List<NotificationResponse>> fetchNotifications() async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    final response = await apiProvider.get('exchange/account/notifications');
    return notificationResponseFromJson(response);
  }
}
