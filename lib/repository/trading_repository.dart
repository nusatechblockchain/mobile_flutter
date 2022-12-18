import 'dart:async';
import 'dart:convert';
import 'package:naga_exchange/models/trading_fee.dart';
import 'package:get/get.dart';
import 'package:naga_exchange/controllers/HomeController.dart';
import 'package:naga_exchange/network/api_provider.dart';
import 'package:naga_exchange/network/request_headers.dart';
import 'package:naga_exchange/models/open_order.dart';

class TradingRepository {
  HomeController homeController = Get.find();

  ApiProvider apiProvider;

  Future<OpenOrder> placeTradingOrder(orderObj) async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    final response = await apiProvider.post('exchange/market/orders', orderObj);
    return OpenOrder.fromJson(json.decode(response));
  }

  Future<TradingFee> fetchTradingFee() async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    final response = await apiProvider.get('exchange/account/member_fee');
    return tradingFeeFromJson(response);
  }
}
