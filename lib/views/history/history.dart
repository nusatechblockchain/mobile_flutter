import 'package:naga_exchange/controllers/history_controller.dart';
import 'package:naga_exchange/controllers/wallet_controller.dart';
import 'package:naga_exchange/views/history/deposit_history.dart';
import 'package:naga_exchange/views/history/trade_history.dart';
import 'package:naga_exchange/views/history/withdraw_history.dart';
import 'package:flutter/material.dart';
import 'package:naga_exchange/models/wallet.dart' as WalletClass;
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> with TickerProviderStateMixin {
  final WalletController walletController = Get.find<WalletController>();
  final HistoryController historyController = Get.put(HistoryController());
  TabController myTabController;

  String getBlockchainLink(currency, txid) {
    var wallets = walletController.walletsList;
    WalletClass.Wallet currencyInfo =
        wallets.firstWhere((wallet) => wallet.currency == currency);
    if (currencyInfo != null) {
      if ((txid != '' && txid != null) &&
          (currencyInfo.explorerTransaction != '' &&
              currencyInfo.explorerTransaction != null)) {
        var bLink =
            currencyInfo.explorerTransaction.replaceFirst('#{txid}', txid);
        return bLink;
      }
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    // var lastIndex = myTabs.length - 1;
    myTabController =
        new TabController(vsync: this, length: 3, initialIndex: 0);

    myTabController.addListener(() {
      print('my index is' + myTabController.index.toString());
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'history.screen.title'.tr,
          style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontFamily: "Gotik",
              fontWeight: FontWeight.w600,
              fontSize: 18.5),
        ),
        iconTheme: IconThemeData(
            color: Theme.of(context).textSelectionTheme.selectionColor),
        elevation: 1.0,
        brightness: Get.isDarkMode ? Brightness.dark : Brightness.light,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Column(
        children: [
          Flexible(
            child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: DefaultTabController(
                        length: 3,
                        child: Scaffold(
                          appBar: PreferredSize(
                            preferredSize: Size.fromHeight(40.0),
                            child: AppBar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              elevation: 0,
                              centerTitle: true,
                              bottom: PreferredSize(
                                  child: Container(
                                    color: Theme.of(context).canvasColor,
                                    height: 2.0,
                                  ),
                                  preferredSize: Size.fromHeight(4.0)),
                              flexibleSpace: SafeArea(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 0.0),
                                    child: new TabBar(
                                      indicator: UnderlineTabIndicator(
                                          borderSide: BorderSide(
                                            width: 4,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          insets: EdgeInsets.only(
                                              left: -8, right: 8, bottom: 0)),
                                      isScrollable: true,
                                      controller: myTabController,
                                      labelPadding:
                                          EdgeInsets.only(left: 0, right: 16),
                                      labelColor:
                                          Theme.of(context).primaryColor,
                                      unselectedLabelColor: Theme.of(context)
                                          .textSelectionTheme
                                          .selectionColor,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      tabs: [
                                        new Tab(
                                          child: Text(
                                            "history.screen.tabs.deposit_history"
                                                .tr,
                                            style: TextStyle(
                                                fontFamily: "Popins",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0),
                                          ),
                                        ),
                                        new Tab(
                                          child: Text(
                                            "history.screen.tabs.withdraw_history"
                                                .tr,
                                            style: TextStyle(
                                                fontFamily: "Popins",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0),
                                          ),
                                        ),
                                        new Tab(
                                          child: Text(
                                            "history.screen.tabs.trade_history"
                                                .tr,
                                            style: TextStyle(
                                                fontFamily: "Popins",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              automaticallyImplyLeading: false,
                            ),
                          ),
                          body: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: new TabBarView(
                              controller: myTabController,
                              children: [
                                DepositHistory(),
                                WithdrawHistory(),
                                TradeHistory()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
