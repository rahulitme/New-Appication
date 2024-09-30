import 'package:news/utils/api.dart';
import 'package:news/utils/strings.dart';

class OtherPageRemoteDataSource {
  Future<dynamic> getOtherPages({required String langId}) async {
    try {
      final body = {LANGUAGE_ID: langId};
      final result = await Api.sendApiRequest(body: body, url: Api.getPagesApi, isGet: true);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
