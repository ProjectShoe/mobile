import 'package:dio/dio.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/model/order_model.dart';
import 'package:shoes_store/services/auth_service.dart';

class OrderRepo {
  final Dio dio = DioClient.getDioInstance();

  Future<bool> addOrder({
    required Map<String, dynamic> data,
  }) async {
    try {
      final result = await dio.post(
        ApiPath.baseUrl + ApiPath.addOrder,
        data: data,
      );
      return result.data['status'] == 'OK';
    } catch (e) {
      return false;
    }
  }

  Future<List<OrderModel>?> getAllOrder() async {
    try {
      final result = await dio.get(ApiPath.baseUrl + ApiPath.getAllOrder);
      print(result.data['data']);
      return (result.data['data'] as List)
          .map((order) => OrderModel.fromJson(order))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
