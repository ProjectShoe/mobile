import 'package:dio/dio.dart';
import 'package:shoes_store/core/constants/api_path.dart';
import 'package:shoes_store/model/product_model.dart';
import 'package:shoes_store/services/auth_service.dart';

class ProductRepo {
  final Dio dio = DioClient.getDioInstance();

  Future<bool> addProduct({
    required String name,
    required String description,
    required String price,
    required String quantity,
    required String code,
  }) async {
    try {
      final result = await dio.post(
        ApiPath.baseUrl + ApiPath.addProduct,
        data: {
          'name': name,
          'description': description,
          'price': price,
          'quantity': quantity,
          'code': code,
          'image': '',
          'type': 'Hot',
        },
      );
      return result.data['status'] == 'OK';
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProduct({
    required String id,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String code,
  }) async {
    try {
      final result = await dio.put(
        '${ApiPath.baseUrl + ApiPath.updateProduct}/$id',
        data: {
          'name': name,
          'description': description,
          'price': price,
          'quantity': quantity,
          'code': code,
        },
      );
      return result.data['status'] == 'OK';
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct({required String id}) async {
    try {
      final result =
          await dio.delete('${ApiPath.baseUrl + ApiPath.deleteProduct}/$id');
      return result.data['status'] == 'OK';
    } catch (e) {
      return false;
    }
  }

  Future<List<ProductModel>?> getAllProduct() async {
    try {
      final result = await dio.get(ApiPath.baseUrl + ApiPath.getAllProduct);
      print("abc $result");
      return (result.data['data'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<ProductModel?> getProductById({required String id}) async {
    try {
      final result =
          await dio.get('${ApiPath.baseUrl + ApiPath.getProductId}$id');
      return ProductModel.fromJson(result.data['data']);
    } catch (e) {
      return null;
    }
  }
}
