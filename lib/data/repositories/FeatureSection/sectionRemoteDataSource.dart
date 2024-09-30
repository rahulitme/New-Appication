import 'package:news/utils/api.dart';
import 'package:news/utils/strings.dart';

class SectionRemoteDataSource {
  Future<dynamic> getSections({required String langId, String? latitude, String? longitude, String? limit, String? offset /* , String? sectionId */}) async {
    try {
      final body = {LANGUAGE_ID: langId, LIMIT: limit, OFFSET: offset};

      if (latitude != null && latitude != "null") body[LATITUDE] = latitude;
      if (longitude != null && longitude != "null") body[LONGITUDE] = longitude;

      final result = await Api.sendApiRequest(body: body, url: Api.getFeatureSectionApi, isGet: true);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
