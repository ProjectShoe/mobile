import 'package:dio/dio.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/core/constants/secure_storage.dart';

class DioClient {
  static final Dio _dio = Dio();

  static Dio getDioInstance() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Gắn accessToken vào Header
        String? token = await SecureStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('api called :' + options.uri.toString());
        print(
          'method: ' + options.method.toString(),
        );
        print('header' + options.headers.toString());
        print(options.data.toString());
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response); // Tiếp tục khi không có lỗi
      },
      onError: (DioError error, handler) async {
        // Kiểm tra lỗi 401 - Token hết hạn
        if (error.response?.statusCode == 403) {
          // Làm mới token
          bool isRefreshed = await _refreshToken();

          if (isRefreshed) {
            // Thử lại request với token mới
            final options = error.requestOptions;
            final newToken = await SecureStorage.getToken();
            options.headers['Authorization'] = 'Bearer $newToken';

            // Gửi lại request
            final response = await _dio.request(
              options.path,
              options: Options(
                method: options.method,
                headers: options.headers,
              ),
              data: options.data,
              queryParameters: options.queryParameters,
            );
            return handler.resolve(response);
          }
        }
        return handler.next(error); // Tiếp tục với lỗi ban đầu
      },
    ));

    return _dio;
  }

  static Future<bool> _refreshToken() async {
    try {
      final String? refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken == null) {
        return false;
      }

      final response = await _dio.post(
        ApiPath.baseUrl + ApiPath.refreshToken,
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final String newAccessToken = response.data['accessToken'];
        final String newRefreshToken = response.data['refreshToken'];

        await SecureStorage.saveToken(newAccessToken);
        await SecureStorage.saveRefreshToken(newRefreshToken);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Refresh token failed: $e');
      return false;
    }
  }
}
