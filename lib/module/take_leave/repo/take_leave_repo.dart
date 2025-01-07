import 'package:dio/dio.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/services/auth_service.dart';

import '../../take_leave_list/model/take_list_model.dart';

class TakeLeaveRepo {
  final Dio dio = DioClient.getDioInstance();

  Future<bool> addTakeLeave(TakeListModel item) async {
    try {
      final result = await dio.post(
        ApiPath.baseUrl + ApiPath.addLeave,
        data: await item.toJson(),
      );
      return result.data['status'] == 'OK';
    } catch (e) {
      rethrow;
    }
  }
}
