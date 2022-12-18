import 'dart:async';
import 'package:naga_exchange/controllers/HomeController.dart';
import 'package:naga_exchange/models/Beneficiary.dart';
import 'package:naga_exchange/network/api_provider.dart';
import 'package:naga_exchange/network/request_headers.dart';
import 'package:get/get.dart';

class BeneficiaryRepository {
  HomeController homeController = Get.find();

  ApiProvider apiProvider;

  Future<List<Beneficiary>> fetchBeneficiaries() async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    final response = await apiProvider.get('exchange/account/beneficiaries');
    return beneficiaryFromJson(response);
  }

  Future<Beneficiary> addBeneficiary(data) async {
    apiProvider = new ApiProvider();
    RequestHeaders requestHeaders = new RequestHeaders();
    apiProvider.headers = requestHeaders.setAuthHeaders();
    final response =
        await apiProvider.post('exchange/account/beneficiaries', data);

    return response;
  }
}
