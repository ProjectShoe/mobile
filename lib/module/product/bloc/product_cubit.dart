import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_store/module/product/bloc/product_state.dart';
import 'package:shoes_store/module/product/repo/product_repo.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitialState());
  final ProductRepo repo = ProductRepo();

  Future<void> addProduct(
      {required String name,
      required String description,
      required String price,
      required String code,
      required String quantity}) async {
    try {
      emit(AddProductInitialState());
      emit(AddProductLoading());
      final result = await repo.addProduct(
          name: name,
          description: description,
          price: price,
          quantity: quantity,
          code: code);
      print(result);
      if (result == true) {
        emit(AddProductSuccess());
      } else {
        emit(AddProductFailed());
      }
    } catch (e) {
      emit(AddProductError(errorMessage: e.toString()));
    }
  }
}

class UpdateProductCubit extends Cubit<UpdateProductState> {
  UpdateProductCubit() : super(UpdateProductInitialState());
  final ProductRepo repo = ProductRepo();

  Future<void> updateProduct(
      String id, String name, String description, double price) async {
    try {
      emit(UpdateProductInitialState());
      emit(UpdateProductLoading());
      final result = await repo.updateProduct(
          id: id,
          name: name,
          description: description,
          price: price,
          code: id,
          quantity: 1);
      if (result == true) {
        emit(UpdateProductSuccess());
      } else {
        emit(UpdateProductFailed());
      }
    } catch (e) {
      emit(UpdateProductError(errorMessage: e.toString()));
    }
  }
}

class DeleteProductCubit extends Cubit<DeleteProductState> {
  DeleteProductCubit() : super(DeleteProductInitialState());
  final ProductRepo repo = ProductRepo();

  Future<void> deleteProduct(String id) async {
    try {
      emit(DeleteProductInitialState());
      emit(DeleteProductLoading());
      final result = await repo.deleteProduct(id: id);
      if (result == true) {
        emit(DeleteProductSuccess());
      } else {
        emit(DeleteProductFailed());
      }
    } catch (e) {
      emit(DeleteProductError(errorMessage: e.toString()));
    }
  }
}

class GetAllProductCubit extends Cubit<GetAllProductState> {
  GetAllProductCubit() : super(GetAllProductInitialState());
  final ProductRepo repo = ProductRepo();

  Future<void> getAllProduct() async {
    try {
      emit(GetAllProductInitialState());
      emit(GetAllProductLoading());
      final result = await repo.getAllProduct();
      if (result != null) {
        emit(GetAllProductSuccess(products: result));
      } else {
        emit(GetAllProductFailed());
      }
    } catch (e) {
      emit(GetAllProductError(errorMessage: e.toString()));
    }
  }
}

class GetProductByIdCubit extends Cubit<GetProductByIdState> {
  GetProductByIdCubit() : super(GetProductByIdInitialState());
  final ProductRepo repo = ProductRepo();

  Future<void> getProductById(String id) async {
    try {
      emit(GetProductByIdInitialState());
      emit(GetProductByIdLoading());
      final result = await repo.getProductById(id: id);
      if (result != null) {
        emit(GetProductByIdSuccess(product: result));
      } else {
        emit(GetProductByIdFailed());
      }
    } catch (e) {
      emit(GetProductByIdError(errorMessage: e.toString()));
    }
  }
}
