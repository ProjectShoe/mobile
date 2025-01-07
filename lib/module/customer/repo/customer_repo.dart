import 'package:dio/dio.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/model/customer_model.dart';
import 'package:shoes_store/services/auth_service.dart';

class CustomerRepo {
  final Dio dio = DioClient.getDioInstance();
  Future<List<CustomerModel>?> getAllCustomer() async {
    try {
      final result = await dio.get(ApiPath.baseUrl + ApiPath.getAllCustomer);
      return (result.data['data'] as List)
          .map((customer) => CustomerModel.fromJson(customer))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<bool> addCustomer(Map<String, dynamic> customerData) async {
    try {
      final response = await dio.post(
        ApiPath.baseUrl + ApiPath.addCustomer,
        data: customerData,
      );
      return response.statusCode == 200; // Trả về true nếu thành công
    } catch (e) {
      return false;
    }
  }
}
