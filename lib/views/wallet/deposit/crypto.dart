import 'package:naga_exchange/controllers/crypto_deposit_controller.dart';
import 'package:naga_exchange/views/wallet/search_wallet_header.dart';
import 'package:flutter/material.dart';
import 'package:naga_exchange/models/wallet.dart' as WalletClass;
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:naga_exchange/utils/Helpers/helper.dart';

class DepositCrypto extends StatefulWidget {
  final WalletClass.Wallet wallet;
  DepositCrypto({Key key, this.wallet}) : super(key: key);

  @override
  _WalletState createState() => _WalletState(wallet: wallet);
}

class _WalletState extends State<DepositCrypto> {
  final WalletClass.Wallet wallet;
  _WalletState({this.wallet});
  CryptoDepositController depositController;

  share(BuildContext context) {
    final _shareAddress = wallet.currency == 'xrp'
        ? depositController.depositAddress.value +
            '?dt=' +
            depositController.depositTag.value
        : depositController.depositAddress.value;
    final RenderBox box = context.findRenderObject();
    Share.share(
        wallet.name +
            ' Address: ' +
            _shareAddress +
            "\n\nhttps://www.nagaexchange.com/",
        subject: 'Naga Exchange',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void initState() {
    depositController =
        Get.put(CryptoDepositController(currency: wallet.currency));
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'crypto_deposit.screen.title'.tr,
          style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontFamily: "Gotik",
              fontWeight: FontWeight.w600,
              fontSize: 18.5),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Theme.of(context).textSelectionTheme.selectionColor),
        elevation: 1.0,
        brightness: Get.isDarkMode ? Brightness.dark : Brightness.light,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Column(children: [
        SearchHeader(screenType: 'deposit', wallet: wallet),
        wallet.depositEnabled
            ? Flexible(
                child: ListView(shrinkWrap: true, children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 16.0,
                        ),
                        Obx(() {
                          if (depositController.isAddressLoading.value) {
                            return _loadingAddressAnimation(context);
                          } else {
                            if (depositController.depositAddress.value == '')
                              return _addressNotFound(context);
                            else
                              return Column(
                                children: [
                                  (depositController.depositTag.value != '')
                                      ? Column(children: [
                                          _showTagDepositInstruction(context),
                                          SizedBox(
                                            height: 16.0,
                                          ),
                                        ])
                                      : Container(),
                                  Column(children: [
                                    _showAddress(context),
                                    Divider(
                                      color: Theme.of(context).hintColor,
                                    ),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                  ]),
                                  (depositController.depositTag.value != '')
                                      ? Column(children: [
                                          _showTag(context),
                                          Divider(
                                            color: Theme.of(context).hintColor,
                                          ),
                                          SizedBox(
                                            height: 16.0,
                                          ),
                                        ])
                                      : Container(),
                                  _showQRCode(context),
                                  Divider(
                                    color: Theme.of(context).hintColor,
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Divider(
                                    color: Theme.of(context).hintColor,
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'crypto_deposit.screen.instruction.title'
                                            .trParams({
                                          'currency':
                                              wallet.currency.toUpperCase()
                                        }),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .textSelectionTheme
                                              .selectionColor,
                                          fontSize: 12,
                                          fontFamily: "Popins",
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '* ' +
                                            'crypto_deposit.screen.instruction.text1'
                                                .trParams({
                                              'currency':
                                                  wallet.currency.toUpperCase()
                                            }),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textSelectionTheme
                                              .selectionColor,
                                          fontSize: 12,
                                          fontFamily: "Popins",
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        '* ' +
                                            'crypto_deposit.screen.instruction.text2'
                                                .trParams(
                                                    {'confirmations': '6'}),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textSelectionTheme
                                              .selectionColor,
                                          fontSize: 12,
                                          fontFamily: "Popins",
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                          }
                        }),
                        SizedBox(
                          height: 16.0,
                        )
                      ],
                    ),
                  ),
                ]),
              )
            : _depositDisabled(context),
      ]),
    );
  }

  Widget _depositDisabled(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      width: double.infinity,
      child: Column(children: <Widget>[
        SizedBox(
          height: 16.0,
        ),
        Icon(
          Icons.lock,
          color: Theme.of(context).primaryColor,
          size: 72.0,
          semanticLabel: 'disabled',
        ),
        SizedBox(
          height: 16.0,
        ),
        Center(
          child: Text(
            'crypto_deposit.screen.disabled'.tr,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
      ]),
    );
  }

  Widget _loadingAddressAnimation(context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: double.infinity,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _addressNotFound(context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 16.0,
          ),
          Container(
            height: 40.0,
            width: 150.0,
            color: Theme.of(context).primaryColor,
            child: GestureDetector(
              onTap: () {
                depositController.fetchDepositAddress(wallet.currency);
              },
              child: Center(
                child: Text(
                  "crypto_deposit.screen.button.generate_address".tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
        ]);
  }

  Widget _showAddress(context) {
    return Container(
      width: double.infinity,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                wallet.currency.toUpperCase() +
                    ' ' +
                    'crypto_deposit.screen.address'.tr,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Popins",
                ),
              ),
              MaterialButton(
                height: 30.0,
                minWidth: 40.0,
                color: Theme.of(context).canvasColor,
                child: Text(
                  "crypto_deposit.screen.button.copy_address".tr,
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 10,
                    fontFamily: "Popins",
                  ),
                ),
                onPressed: () {
                  Helper.copyToClipBoard(
                      depositController.depositAddress.value);
                },
                splashColor: Theme.of(context).canvasColor.withOpacity(0.5),
              )
            ],
          ),
          Text(
            depositController.depositAddress.value,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontSize: 14,
              fontFamily: "Popins",
            ),
          ),
        ],
      ),
    );
  }

  Widget _showQRCode(context) {
    return Column(children: [
      QrImage(
          data: depositController.depositAddress.value,
          version: QrVersions.auto,
          size: 160.0,
          backgroundColor: Colors.white),
      SizedBox(
        height: 16.0,
      ),
      MaterialButton(
        height: 40.0,
        minWidth: 150.0,
        color: Theme.of(context).canvasColor,
        child: new Text(
          "crypto_deposit.screen.button.share".tr,
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 10,
            fontFamily: "Popins",
          ),
        ),
        onPressed: () {
          share(context);
        },
        splashColor: Theme.of(context).canvasColor.withOpacity(0.5),
      )
    ]);
  }

  Widget _showTagDepositInstruction(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Icon(
          Icons.emoji_objects,
          size: 15.0,
          color: Theme.of(context).errorColor,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'crypto_deposit.screen.tag.instruction'
                  .trParams({'currency': wallet.currency.toUpperCase()}),
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: "Popins",
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _showTag(context) {
    return Container(
      width: double.infinity,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                wallet.currency.toUpperCase() + ' Tag',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Popins',
                    color: Theme.of(context).hintColor),
              ),
              Spacer(flex: 1),
              MaterialButton(
                height: 30.0,
                minWidth: 40.0,
                color: Theme.of(context).canvasColor,
                child: new Text(
                  "crypto_deposit.screen.button.copy_tag".tr,
                  style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Popins',
                      color: Theme.of(context).hintColor),
                ),
                onPressed: () {
                  Helper.copyToClipBoard(depositController.depositTag.value);
                },
                splashColor: Theme.of(context).canvasColor,
              )
            ],
          ),
          Text(
            depositController.depositTag.value,
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              fontSize: 14,
              fontFamily: "Popins",
            ),
          ),
        ],
      ),
    );
  }
}
