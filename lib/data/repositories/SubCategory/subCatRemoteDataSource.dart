import 'package:news/utils/api.dart';
import 'package:news/utils/strings.dart';

class SubCategoryRemoteDataSource {
  Future<dynamic> getSubCategory({required String catId, required String langId}) async {
    try {
      final body = {CATEGORY_ID: catId, LANGUAGE_ID: langId};
      final result = await Api.sendApiRequest(body: body, url: Api.getSubCategoryApi, isGet: true);

      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
