import 'package:naga_exchange/controllers/error_controller.dart';
import 'package:naga_exchange/controllers/market_controller.dart';
import 'package:naga_exchange/controllers/web_socket_controller.dart';
import 'package:naga_exchange/models/formated_market.dart';
import 'package:naga_exchange/repository/market_repository.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'package:naga_exchange/utils/Helpers/ws_helper.dart';
import 'package:naga_exchange/utils/Helpers/helper.dart';

class MarketDetailController extends GetxController {
  var initialLineGraphTimeSlots = [
    {
      "key": "15m",
      "name": "15 minutes",
      "valueInMinute": "15",
      "isActive": false
    },
    {"key": "1h", "name": "1 hour", "valueInMinute": "60", "isActive": false},
    {"key": "4h", "name": "4 hour", "valueInMinute": "240", "isActive": false},
    {
      "key": "12h",
      "name": "12 hour",
      "valueInMinute": "720",
      "isActive": false
    },
    {"key": "1D", "name": "1 day", "valueInMinute": "1440", "isActive": false},
    {
      "key": "1w",
      "name": "1 week",
      "valueInMinute": "10080",
      "isActive": false
    },
    {
      "key": "More",
      "name": "show_more",
      "valueInMinute": "0",
      "isActive": false
    },
  ].obs;
  var lineGraphTimeSlots = [
    {"key": "1m", "name": "1 minute", "valueInMinute": "1", "isActive": false},
    {"key": "5m", "name": "5 minutes", "valueInMinute": "5", "isActive": false},
    {
      "key": "30m",
      "name": "30 minutes",
      "valueInMinute": "30",
      "isActive": false
    },
    {"key": "2h", "name": "2 hours", "valueInMinute": "120", "isActive": false},
    {"key": "6h", "name": "6 hours", "valueInMinute": "360", "isActive": false},
    {"key": "3D", "name": "3 days", "valueInMinute": "4320", "isActive": false},
    {
      "key": "1M",
      "name": "1 month",
      "valueInMinute": "43800",
      "isActive": false
    },
  ].obs;
  var dropdownShown = false.obs;
  var states = [
    // {"type": "line", "name": "Line", "isActive": false},
    // {"type": "space", "name": "|", "isActive": false},
    {"type": "main", "name": "MA", "state": MainState.MA, "isActive": false},
    {
      "type": "main",
      "name": "BOLL",
      "state": MainState.BOLL,
      "isActive": false
    },
    {"type": "space", "name": "|", "isActive": false},
    {
      "type": "secondry",
      "name": "MACD",
      "state": SecondaryState.MACD,
      "isActive": false
    },
    {
      "type": "secondry",
      "name": "RSI",
      "state": SecondaryState.RSI,
      "isActive": false
    },
    {
      "type": "secondry",
      "name": "WR",
      "state": SecondaryState.WR,
      "isActive": false
    },
    {
      "type": "secondry",
      "name": "KDJ",
      "state": SecondaryState.KDJ,
      "isActive": false
    },
    {"type": "space", "name": "|", "isActive": false},
    {"type": "vol", "name": "Vol", "isActive": false},
  ].obs;
  var secondryStates = [
    {"name": "MACD", "state": SecondaryState.MACD},
    {"name": "RSI", "state": SecondaryState.RSI},
    {"name": "KDJ", "state": SecondaryState.KDJ},
  ].obs;
  var selectedOption = Map<String, dynamic>().obs;
  Rx<FormatedMarket> market = FormatedMarket().obs;
  var formatedKLineData = <KLineEntity>[].obs;
  var isKLineLoading = true.obs;
  var _mainState = MainState.NONE.obs;
  var _secondaryState = SecondaryState.NONE.obs;
  var _volHidden = true.obs;

  var _isLine = false.obs;
  var isChinese = false;

  var bidsData = <DepthEntity>[].obs;
  var asksData = <DepthEntity>[].obs;

  MarketController marketController = Get.find();
  WebSocketController webSocketController = Get.find();

  ErrorController errorController = new ErrorController();

  get mainState => this._mainState.value;
  set mainState(index) => this._mainState.value = index;

  get secondaryState => this._secondaryState.value;
  set secondaryState(index) => this._secondaryState.value = index;

  get volHidden => this._volHidden.value;
  set volHidden(index) => this._volHidden.value = index;

  get isLine => this._isLine.value;
  set isLine(index) => this._isLine.value = index;

  @override
  void onInit() async {
    market.value = marketController.selectedMarket.value;
    await setDefaultValues();
    await getKlineData();

    super.onInit();
  }

  @override
  void onReady() async {
    marketController.orderBookSequence = -1;
    marketController.asks.clear();
    marketController.bids.clear();
    await webSocketController.subscribeKline(
        market.value, selectedOption['valueInMinute']);
    getKlineDataFromWS();

    await webSocketController.subscribeOrderBookInc(market.value);
    getOrderBookDataFromWS();
    super.onReady();
  }

  void updateCurrentMarket(FormatedMarket newMarket) async {
    webSocketController.unSubscribeKline(
        market.value, selectedOption['valueInMinute']);
    webSocketController.unSubscribeOrderBookInc(market.value);
    market.value = newMarket;
    marketController.selectedMarket.value = newMarket;

    await getKlineData();
    webSocketController.subscribeKline(
        newMarket, selectedOption['valueInMinute']);
    webSocketController.subscribeOrderBookInc(newMarket);
  }

  void updateKlineTimeOption(newOption) async {
    webSocketController.unSubscribeKline(
        market.value, selectedOption['valueInMinute']);

    selectedOption.assignAll(newOption);
    await getKlineData();
    webSocketController.subscribeKline(
        market.value, selectedOption['valueInMinute']);
  }

  Future<void> setDefaultValues() async {
    selectedOption.assignAll(initialLineGraphTimeSlots[0]);
  }

  Future<Null> refreshPage() async {
    onClose();
    onInit();
    onReady();
  }

  Future<void> getKlineData() async {
    MarketRepository _marketRepository = new MarketRepository();
    try {
      isKLineLoading(true);
      var period = selectedOption['valueInMinute'];
      var currentTime = DateTime.now();
      var from = currentTime.millisecondsSinceEpoch;
      var to = currentTime
          .add(new Duration(minutes: int.parse(period)))
          .millisecondsSinceEpoch;
      // var from = currentTime.millisecondsSinceEpoch;
      // var to =
      //     currentTime.subtract(new Duration(days: 3)).millisecondsSinceEpoch;
      var data = await _marketRepository.fetchKLineData(
          market.value.id, period, from, to);
      var keys = ['time', 'open', 'high', 'low', 'close', 'vol'];
      for (var i = 0; i < data.length; i++) {
        Map<String, dynamic> newObj = {};
        KLineEntity klineObj;
        for (var j = 0; j < keys.length; j++) {
          newObj.addAll({keys[j]: data[i][j]});
        }

        klineObj = new KLineEntity.fromJson(newObj);
        formatedKLineData.add(klineObj);
        DataUtil.calculate(formatedKLineData);
        isKLineLoading(false);
      }
    } catch (error) {
      isKLineLoading(false);
      print(error);
      errorController.handleError(error);
    }
  }

  void makeDepthData() {
    asksData.clear();
    bidsData.refresh();
    asksData.refresh();
    bidsData.clear();
    var bids = marketController.bids
        .map(
            (item) => DepthEntity(double.parse(item[0]), double.parse(item[1])))
        .toList()
        .cast<DepthEntity>();
    var asks = marketController.asks
        .map(
            (item) => DepthEntity(double.parse(item[0]), double.parse(item[1])))
        .toList()
        .cast<DepthEntity>();
    initDepth(bids, asks);
  }

  void initDepth(List<DepthEntity> bids, List<DepthEntity> asks) {
    if (bids == null || asks == null || bids.isEmpty || asks.isEmpty) return;

    double amount = 0.0;
    bids?.sort((left, right) => left.price.compareTo(right.price));
    bids.reversed.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      bidsData.insert(0, item);
    });

    amount = 0.0;
    asks?.sort((left, right) => left.price.compareTo(right.price));
    asks?.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      asksData.add(item);
    });
  }

  void getKlineDataFromWS() {
    webSocketController.streamController.value.stream.listen((message) {
      var data = json.decode(message);
      if (data
          .containsKey('${market.value.id}.kline-' + selectedOption['key'])) {
        var keys = ['time', 'open', 'high', 'low', 'close', 'vol'];
        Map<String, dynamic> newObj = {};
        KLineEntity klineObj;
        for (var i = 0; i < keys.length; i++) {
          var kLineEntry = double.parse(
              data['${market.value.id}.kline-' + selectedOption['key']][i]);
          newObj.addAll({keys[i]: kLineEntry});
        }
        klineObj = new KLineEntity.fromJson(newObj);
        formatedKLineData.add(klineObj);
        DataUtil.calculate(formatedKLineData);
      }
    }, onDone: () {
      print("K Line data done");
    }, onError: (error) {
      print("K Line data Error");
    });
  }

  void getOrderBookDataFromWS() {
    webSocketController.streamController.value.stream.listen((message) {
      var data = json.decode(message);
      if (data.containsKey('${market.value.id}.ob-snap')) {
        marketController.asks
            .assignAll(data['${market.value.id}.ob-snap']['asks']);
        marketController.bids
            .assignAll(data['${market.value.id}.ob-snap']['bids']);
        marketController.orderBookSequence =
            data['${market.value.id}.ob-snap']['sequence'];

        marketController.maxVolume.value =
            Helper.calcMaxVolume(marketController.bids, marketController.asks);
        marketController.orderBookEntryBids
            .assignAll(Helper.accumulateVolume(marketController.bids));
        marketController.orderBookEntryAsks
            .assignAll(Helper.accumulateVolume(marketController.asks));
        makeDepthData();
      }
      if (data.containsKey('${market.value.id}.ob-inc')) {
        var updatedAsksData = [];
        var updatedBidsData = [];
        if (marketController.orderBookSequence == -1) {
          // print("OrderBook increment received before snapshot");
          return;
        }
        if (marketController.orderBookSequence + 1 !=
            data['${market.value.id}.ob-inc']['sequence']) {
          // print(
          //     'Bad sequence detected in incremental orderbook previous: ${marketController.orderBookSequence}, event: ' +
          //         data['${market.value.id}.ob-inc']['sequence'].toString());
          // emitter(rangerDisconnectFetch());

          return;
        }
        if (data['${market.value.id}.ob-inc']['asks'] != null) {
          var asks = data['${market.value.id}.ob-inc']['asks'];
          if (WsHelper.isArray(asks[0].toString())) {
            for (var i = 0; i < asks.length; i++) {
              updatedAsksData = WsHelper.handleIncrementalUpdate(
                  marketController.asks, asks[i], 'asks');
            }
          } else {
            updatedAsksData = WsHelper.handleIncrementalUpdate(
                marketController.asks, asks, 'asks');
          }

          updatedAsksData = updatedAsksData.length >= 10
              ? updatedAsksData.sublist(0, 10)
              : updatedAsksData;
          marketController.asks.assignAll(updatedAsksData);
          marketController.asks.refresh();
          marketController.maxVolume.value =
              Helper.calcMaxVolume(marketController.bids, updatedAsksData);
          marketController.orderBookEntryBids
              .assignAll(Helper.accumulateVolume(marketController.bids));
          marketController.orderBookEntryAsks
              .assignAll(Helper.accumulateVolume(updatedAsksData));
          makeDepthData();
        }
        if (data['${market.value.id}.ob-inc']['bids'] != null) {
          var bids = data['${market.value.id}.ob-inc']['bids'];
          if (WsHelper.isArray(bids[0].toString())) {
            for (var i = 0; i < bids.length; i++) {
              updatedBidsData = WsHelper.handleIncrementalUpdate(
                  marketController.bids, bids[i], 'bids');
            }
          } else {
            updatedBidsData = WsHelper.handleIncrementalUpdate(
                marketController.bids, bids, 'bids');
          }
          updatedBidsData = updatedBidsData.length >= 10
              ? updatedBidsData.sublist(0, 10)
              : updatedBidsData;

          marketController.bids.assignAll(updatedBidsData);
          marketController.bids.refresh();
          marketController.maxVolume.value =
              Helper.calcMaxVolume(updatedBidsData, marketController.asks);
          marketController.orderBookEntryBids
              .assignAll(Helper.accumulateVolume(updatedBidsData));
          marketController.orderBookEntryAsks
              .assignAll(Helper.accumulateVolume(marketController.asks));
          makeDepthData();
        }
        marketController.orderBookSequence =
            data['${market.value.id}.ob-inc']['sequence'];
      }
    }, onDone: () {
      print("Task Done1");
    }, onError: (error) {
      print("Some Error1");
    });
  }

  @override
  void onClose() {
    print('Market onClose Called!');
    webSocketController.unSubscribeKline(
        market.value, selectedOption['valueInMinute']);
    webSocketController.unSubscribeOrderBookInc(market.value);
    super.onClose();
  }
}
