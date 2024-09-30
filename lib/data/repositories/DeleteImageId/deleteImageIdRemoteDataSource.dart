import '../../../utils/api.dart';
import '../../../utils/strings.dart';

class DeleteImageRemoteDataSource {
  Future deleteImage({required String imageId}) async {
    try {
      final body = {
        ID: imageId,
      };
      final result = await Api.sendApiRequest(
        body: body,
        url: Api.setDeleteImageApi,
      );
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
