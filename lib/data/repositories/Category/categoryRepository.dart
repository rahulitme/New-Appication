import 'package:news/data/models/CategoryModel.dart';
import 'package:news/data/repositories/Category/categoryRemoteDataSource.dart';
import 'package:news/utils/strings.dart';

class CategoryRepository {
  static final CategoryRepository _notificationRepository = CategoryRepository._internal();

  late CategoryRemoteDataSource _notificationRemoteDataSource;

  factory CategoryRepository() {
    _notificationRepository._notificationRemoteDataSource = CategoryRemoteDataSource();
    return _notificationRepository;
  }

  CategoryRepository._internal();

  Future<Map<String, dynamic>> getCategory({required String offset, required String limit, required String langId}) async {
    final result = await _notificationRemoteDataSource.getCategory(limit: limit, offset: offset, langId: langId);

    return (result[ERROR])
        ? {ERROR: result[ERROR], MESSAGE: result[MESSAGE]}
        : {ERROR: result[ERROR], "total": result[TOTAL], "Category": (result[DATA] as List).map((e) => CategoryModel.fromJson(e)).toList()};
  }
}
