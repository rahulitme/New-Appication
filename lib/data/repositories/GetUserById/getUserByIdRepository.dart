import 'package:news/data/repositories/GetUserById/getUserByIdDataSource.dart';
import 'package:news/utils/strings.dart';

class GetUserByIdRepository {
  static final GetUserByIdRepository _getUserByIdRepository = GetUserByIdRepository._internal();

  late GetUserByIdRemoteDataSource _getUserByIdRemoteDataSource;

  factory GetUserByIdRepository() {
    _getUserByIdRepository._getUserByIdRemoteDataSource = GetUserByIdRemoteDataSource();
    return _getUserByIdRepository;
  }

  GetUserByIdRepository._internal();

  Future<Map<String, dynamic>> getUserById() async {
    final result = await _getUserByIdRemoteDataSource.getUserById();
    return result[DATA];
  }
}
