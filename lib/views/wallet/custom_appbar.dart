import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naga_exchange/models/wallet.dart' as WalletClass;

class WalletCustomAppbar extends StatelessWidget {
  final String title;
  final String screenType;
  final WalletClass.Wallet wallet;
  WalletCustomAppbar({this.title, this.screenType, this.wallet});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
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
    );
  }
}
