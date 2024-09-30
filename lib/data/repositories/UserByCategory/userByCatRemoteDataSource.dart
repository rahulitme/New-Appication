import 'package:news/utils/api.dart';

class UserByCatRemoteDataSource {
  Future<dynamic> getUserById() async {
    try {
      final result = await Api.sendApiRequest(body: {}, url: Api.getUserByIdApi, isGet: true);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
