import 'package:news/utils/api.dart';
import 'package:news/utils/strings.dart';

class CategoryRemoteDataSource {
  Future<dynamic> getCategory({required String limit, required String offset, required String langId}) async {
    try {
      final body = {LIMIT: limit, OFFSET: offset, LANGUAGE_ID: langId};
      final result = await Api.sendApiRequest(body: body, url: Api.getCatApi, isGet: true);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
