import 'package:dio/dio.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/core/constants/secure_storage.dart';
import 'package:shoes_store/services/auth_service.dart';

class LoginRepo {
  Future<bool> login({required String email, required String password}) async {
    final Dio dio = DioClient.getDioInstance();
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    try {
      final result = await dio.post(
        ApiPath.baseUrl + ApiPath.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final responseData = result.data;

      if (responseData != null && responseData['status'] == 'OK') {
        final String token = responseData['accessToken'];
        final String refreshToken = responseData['refreshToken'];
        final String userId = responseData['data']['_id'];
        final bool isActive = responseData['data']['isActive'];
        if (isActive == false) return false;
        await SecureStorage.saveToken(token);
        await SecureStorage.saveRefreshToken(refreshToken);
        await SecureStorage.saveUserId(userId);
        print(await SecureStorage.getUserId());

        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      return false;
    }
  }

  Future<bool> logout({required String email, required String password}) async {
    final Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    try {
      final result = await dio.post(
        ApiPath.baseUrl + ApiPath.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      return result.data['status'] == 'OK';
    } on DioError catch (e) {
      return false;
    }
  }
}
