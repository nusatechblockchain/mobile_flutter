import 'package:naga_exchange/component/no_data.dart';
import 'package:naga_exchange/controllers/open_orders_controller.dart';
import 'package:naga_exchange/models/formated_market.dart';
import 'package:naga_exchange/models/open_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class OpenOrders extends StatelessWidget {
  final FormatedMarket formatedMarket;
  final OpenOrdersController openOrdersController;
  OpenOrders({this.formatedMarket})
      : openOrdersController = Get.put(
          OpenOrdersController(formatedMarket: formatedMarket),
        );
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Row(children: [
              Text(
                'open_order.screen.title'.tr,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Popins',
                    fontWeight: FontWeight.bold),
              ),
              Text(
                ' (' +
                    openOrdersController.openOrdersSortedList.length
                        .toString() +
                    ')',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Popins',
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          Container(
            width: double.infinity,
            height: 1,
            decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (openOrdersController.openOrdersList.length > 0)
                  Row(children: [
                    Checkbox(
                      // checkColor: Colors.yellowAccent, // color of tick Mark
                      activeColor: Theme.of(context).primaryColor,
                      value: openOrdersController.hideOtherOrders.value,
                      onChanged: (bool value) {
                        openOrdersController.hideOrShowOtherOrder();
                      },
                    ),
                    InkWell(
                      onTap: () {
                        openOrdersController.hideOrShowOtherOrder();
                      },
                      child: Text(
                        'open_order.screen.hide_pair'.tr,
                        style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Popins",
                            fontSize: 15.0),
                      ),
                    ),
                  ]),
                if (openOrdersController.openOrdersSortedList.length > 0)
                  MaterialButton(
                    height: 30.0,
                    minWidth: 40.0,
                    color: Theme.of(context).canvasColor,
                    child: Text(
                      "open_order.screen.cancel_all.button".tr,
                      style: TextStyle(
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Popins",
                          fontSize: 12.0),
                    ),
                    onPressed: () {
                      cancelOrderAlert(true);
                    },
                    splashColor: Theme.of(context).canvasColor.withOpacity(0.5),
                  )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          ),
          Obx(() {
            if (openOrdersController.isLoading.value)
              return Container(
                  width: double.infinity,
                  height: 200,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            else
              return _openOrdersLoaded(
                  context, openOrdersController.openOrdersSortedList);
          }),
        ],
      );
    });
  }

  Widget _openOrdersLoaded(BuildContext context, List<OpenOrder> openOrders) {
    return openOrders.isEmpty
        ? NoData()
        : Container(
            height: 200.0,
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: openOrders.length,
              itemBuilder: (BuildContext ctx, int i) {
                return _openOrders(context, openOrders[i]);
              },
            ),
          );
  }

  Widget _openOrders(BuildContext context, OpenOrder openOrder) {
    var executedVolume = double.parse(openOrder.originVolume) -
        double.parse(openOrder.remainingVolume);
    // var remainingAmount = double.parse(openOrder.remainingVolume);
    // var total =
    //     double.parse(openOrder.originVolume) * double.parse(openOrder.price);
    var filled =
        ((executedVolume / double.parse(openOrder.originVolume)) * 100);
    // var priceFixed = formatedMarket.pricePrecision;
    // var amountFixed = formatedMarket.amountPrecision;
    String formattedDate =
        DateFormat('yyyy-MM-dd hh:mm:ss').format(openOrder.createdAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Container(
          child: Column(
        children: [
          Row(
            children: [
              Text(
                openOrder.side == 'buy'
                    ? 'open_order.screen.buy_limit'.tr
                    : 'open_order.screen.sell_limit'.tr,
                style: TextStyle(
                    color: openOrder.side == 'buy'
                        ? Color(0xFF00C087)
                        : Colors.redAccent.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Popins",
                    fontSize: 13.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Text(
                  openOrder.market.toUpperCase(),
                  style: TextStyle(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Popins",
                      fontSize: 15.0),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Text(
                formattedDate,
                style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Popins",
                    fontSize: 13.0),
              ),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 3.0,
                  percent: filled / 100,
                  center: Text(filled.toStringAsFixed(0) + '%',
                      style: TextStyle(
                          color: openOrder.side == 'buy'
                              ? Color(0xFF00C087)
                              : Colors.redAccent,
                          fontFamily: "Popins",
                          fontSize: 13.0)),
                  progressColor: openOrder.side == 'buy'
                      ? Color(0xFF00C087)
                      : Colors.redAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 36.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'open_order.screen.amount'.tr,
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.7),
                            fontFamily: "Popins",
                            fontSize: 13.0),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'open_order.screen.price'.tr,
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.7),
                            fontFamily: "Popins",
                            fontSize: 13.0),
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          (executedVolume).toStringAsFixed(6),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionColor,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Popins",
                              fontSize: 13.0),
                        ),
                        Text(
                          '/',
                          style: TextStyle(
                              fontFamily: "Popins",
                              fontSize: 13.0,
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionColor),
                        ),
                        Text(
                          double.parse(openOrder.originVolume)
                              .toStringAsFixed(6),
                          style: TextStyle(
                            fontFamily: "Popins",
                            fontSize: 13.0,
                            color: Theme.of(context).hintColor.withOpacity(0.7),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        double.parse(openOrder.price).toStringAsFixed(2),
                        style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Popins",
                            fontSize: 13.0),
                      ),
                    ]),
              ),
              Spacer(flex: 1),
              MaterialButton(
                height: 30.0,
                minWidth: 40.0,
                color: Theme.of(context).canvasColor,
                // textColor: Colors.white,
                child: Text(
                  "open_order.screen.cancel.button".tr,
                  style: TextStyle(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Popins",
                      fontSize: 12.0),
                ),
                onPressed: () {
                  cancelOrderAlert(false, openOrder.id);
                },
                splashColor: Theme.of(context).canvasColor.withOpacity(0.5),
              )
            ],
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            height: 1,
            decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          ),
        ],
      )),
    );
  }

  void cancelOrderAlert(bool cancelAll, [int orderId]) {
    openOrdersController.cancelOpenOrders(cancelAll, orderId);
    // Get.dialog(AlertDialog(
    //  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //   title: Text(cancelAll ? 'Cancel All Orders?' : 'Cancel Order?'),
    //   content: Text('You may not be able to revent this action.'),
    //   actions: [
    //     MaterialButton(
    //       textColor: Theme.of(context).hintColor.withOpacity(0.8),
    //       onPressed: () {
    //         Get.back();
    //       },
    //       child: Text('CANCEL'),
    //     ),
    //     MaterialButton(
    //       textColor: Theme.of(context).primaryColor,
    //       onPressed: () {
    //         Get.back();
    //         openOrdersController.cancelOpenOrders(cancelAll, orderId);
    //       },
    //       child: Text('CONFIRM'),
    //     ),
    //   ],
    // ));
  }
}
