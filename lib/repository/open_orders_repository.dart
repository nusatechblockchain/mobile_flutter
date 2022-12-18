import 'dart:async';
import 'dart:convert';
import 'package:naga_exchange/models/open_order.dart';
import 'package:naga_exchange/network/api_provider.dart';
import 'package:naga_exchange/network/request_headers.dart';

class OpenOrdersRepository {
  ApiProvider apiProvider;

  Future<List<OpenOrder>> fetchOpenOrders(String marketId) async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    // var url = 'exchange/market/orders?market=${marketId}&state=wait';
    var url = 'exchange/market/orders?state=wait';
    final response = await apiProvider.get(url);
    return openOrderFromJson(response);
  }

  Future<OpenOrder> cancelOpenOrder(int orderId, dynamic reqObj) async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    // var url = 'exchange/market/orders/cancel/${orderId}';
    var url = 'exchange/market/orders/$orderId/cancel';
    final response = await apiProvider.post(url, reqObj);
    return OpenOrder.fromJson(json.decode(response));
  }

  Future<List<OpenOrder>> cancelAllOpenOrders(dynamic reqObj) async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    var url = 'exchange/market/orders/cancel';
    final response = await apiProvider.post(url, reqObj);
    return openOrderFromJson(response);
  }
}
