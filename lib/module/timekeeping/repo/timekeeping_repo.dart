import 'package:dio/dio.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/services/auth_service.dart';

import '../model/timekeeping_model.dart';

class TimeKeepingRepo {
  final Dio dio = DioClient.getDioInstance();

  Future<String> addTimeKeeping(TimeKeepingModel item) async {
    try {
      final result = await dio.post(
        ApiPath.baseUrl + ApiPath.addTime,
        data: await item.toJson(),
      );
      return result.data['message'];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TimeMyKeepingModel>> getMyTimeKeeping() async {
    try {
      final result = await dio.get(
        ApiPath.baseUrl + ApiPath.getAllTime,
      );
      if (result.data['status'] == 'OK') {
        return (result.data['data'] as List)
            .map(
                (it) => TimeMyKeepingModel.formJson(it as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
