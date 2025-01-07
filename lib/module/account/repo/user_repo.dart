import 'package:dio/dio.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/services/auth_service.dart';

class UserRepo {
  final Dio dio = DioClient.getDioInstance();

  Future<bool> addUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final result = await dio.post(
        ApiPath.baseUrl + ApiPath.addUser,
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      return result.data['status'] == 'OK';
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUser({
    required String id,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final result = await dio.put(
        '${ApiPath.baseUrl + ApiPath.updateUser}/$id',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      return result.data['status'] == 'OK';
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUser({required String id}) async {
    try {
      final result =
          await dio.delete('${ApiPath.baseUrl + ApiPath.deleteUser}/$id');
      return result.data['status'] == 'OK';
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>?> getAllUser() async {
    try {
      final result = await dio.get(ApiPath.baseUrl + ApiPath.getAllUser);
      return result.data['data'];
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserById({required String id}) async {
    try {
      final result = await dio.get('${ApiPath.baseUrl + ApiPath.getUserId}$id');
      return result.data['data'];
    } catch (e) {
      return null;
    }
  }
}
