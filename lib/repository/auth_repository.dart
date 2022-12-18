import 'dart:async';
import 'package:naga_exchange/network/api_provider.dart';
import 'package:naga_exchange/models/user.dart';

class AuthRepository {
  ApiProvider apiProvider = new ApiProvider();

  Future<User> authenticate(dynamic authObject) async {
    final response =
        await apiProvider.post('account/identity/sessions', authObject);
    return userFromJson(response);
  }

  Future<User> register(dynamic registerObject) async {
    final response =
        await apiProvider.post('account/identity/users', registerObject);
    return userFromJson(response);
  }

  Future<dynamic> resendVerificationCode(dynamic object) async {
    final response = await apiProvider.post(
        'account/identity/users/email/generate_code', object);
    return response;
  }
}
