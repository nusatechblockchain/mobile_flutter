import 'package:naga_exchange/controllers/SnackbarController.dart';
import 'package:naga_exchange/controllers/error_controller.dart';
import 'package:naga_exchange/models/fiat_deposit_details.dart';
import 'package:naga_exchange/repository/wallet_repository.dart';
import 'package:get/get.dart';

class FiatDepositController extends GetxController {
  final String currency;
  FiatDepositController({this.currency});

  var isLoading = true.obs;
  var isDepositDetailLoading = true.obs;
  var depositDetails = <FiatDepositDetails>[].obs;
  SnackbarController snackbarController;
  ErrorController errorController = new ErrorController();

  @override
  void onInit() {
    // fetchDepositBankDetails(currency);

    super.onInit();
  }

  fetchDepositBankDetails(currency) async {
    WalletRepository _walletRepository = new WalletRepository();
    try {
      isDepositDetailLoading(true);
      var response = await _walletRepository.fetchFiatDepositDetail();
      depositDetails.assignAll(response);

      isDepositDetailLoading(false);
    } catch (error) {
      print(error);
      isDepositDetailLoading(false);
      errorController.handleError(error);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
