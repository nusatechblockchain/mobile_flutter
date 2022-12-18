import 'dart:async';
import 'package:naga_exchange/models/KLine.dart';
import 'package:naga_exchange/models/sparkline_response.dart';
import 'package:naga_exchange/network/api_provider.dart';
import 'package:naga_exchange/models/market.dart';
import 'package:naga_exchange/models/market_ticker.dart';
import 'package:naga_exchange/network/request_headers.dart';

class MarketRepository {
  ApiProvider apiProvider;
  Future<List<Market>> fetchMarkets() async {
    apiProvider = new ApiProvider();
    final response = await apiProvider.get('exchange/public/markets');
    return marketFromJson(response);
  }

  Future<SparkLineResponse> fetchMarketSparkLineData(String marketId) async {
    apiProvider = new ApiProvider();
    final response =
        await apiProvider.get('exchange/public/markets/$marketId/spark-line');
    // await apiProvider.get('exchange/public/markets/ethbtc/spark-line');
    return sparkLineResponseFromJson(response);
  }

  Future<Map<String, MarketTicker>> fetchMarketsTickers() async {
    final response = await apiProvider.get('exchange/public/markets/tickers');
    return marketTickerFromJson(response);
  }

  Future<List<List<double>>> fetchKLineData(
      String market, String period, int from, int to) async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    final response = await apiProvider
        .get('exchange/public/markets/$market/k-line?period=$period');
    // final response = await apiProvider.get(
    //     'exchange/public/markets/$market/k-line?period=$period&time_from=$from&time_to=$to');
    return kLineFromJson(response);
  }
}
