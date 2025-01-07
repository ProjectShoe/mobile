import 'package:dio/dio.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/services/auth_service.dart';

import '../model/take_list_model.dart';

class TakeLeaveListRepo {
  final Dio dio = DioClient.getDioInstance();

  Future<List<TakeListModel>> getTakeLeaveList() async {
    try {
      final result = await dio.get(ApiPath.baseUrl + ApiPath.getLeaveList);
      return (result.data['data'] as List)
          .map((i) => TakeListModel.fromJson(i))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
