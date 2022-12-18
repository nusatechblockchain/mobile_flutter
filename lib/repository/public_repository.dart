import 'dart:async';
import 'package:naga_exchange/models/MemberLevel.dart';
import 'package:naga_exchange/network/api_provider.dart';

class PublicRepository {
  ApiProvider apiProvider = new ApiProvider();

  Future<MemberLevel> fetchMemberLevels() async {
    final response = await apiProvider.get('exchange/public/member-levels');
    return memberLevelFromJson(response);
  }
}
