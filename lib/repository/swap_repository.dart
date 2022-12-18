import 'dart:async';
import 'package:naga_exchange/controllers/HomeController.dart';
import 'package:naga_exchange/models/swap_history_response.dart';
import 'package:naga_exchange/network/api_provider.dart';
import 'package:naga_exchange/network/request_headers.dart';
import 'package:get/get.dart';
import 'dart:convert';

class SwapRepository {
  HomeController homeController = Get.find();

  ApiProvider apiProvider;

  Future<dynamic> fetchExchangeRate(exchangeRateRequestObj) async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    final response = await apiProvider.post(
        'exchange/account/exchanges/rate', exchangeRateRequestObj);
    return json.decode(response);
  }

  Future<dynamic> exchangeRequest(exchangeRequestObj) async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    final response = await apiProvider.post(
        'exchange/account/exchanges/exchange', exchangeRequestObj);
    return response;
  }

  Future<List<SwapHistoryResponse>> fetchSwapHistory() async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    final response = await apiProvider.get('exchange/account/exchanges/history');
    return swapHistoryResponseFromJson(response);
  }
}
