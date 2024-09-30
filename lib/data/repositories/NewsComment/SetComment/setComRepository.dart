import 'package:news/data/repositories/NewsComment/SetComment/setComRemoteDataSource.dart';
import 'package:news/data/models/CommentModel.dart';
import 'package:news/utils/strings.dart';

class SetCommentRepository {
  static final SetCommentRepository _setCommentRepository = SetCommentRepository._internal();

  late SetCommentRemoteDataSource _setCommentRemoteDataSource;

  factory SetCommentRepository() {
    _setCommentRepository._setCommentRemoteDataSource = SetCommentRemoteDataSource();
    return _setCommentRepository;
  }
  SetCommentRepository._internal();
  Future<Map<String, dynamic>> setComment({required String parentId, required String newsId, required String message}) async {
    final result = await _setCommentRemoteDataSource.setComment(parentId: parentId, newsId: newsId, message: message);
    return {"SetComment": (result[DATA] as List).map((e) => CommentModel.fromJson(e)).toList(), "total": result[TOTAL]};
  }
}
