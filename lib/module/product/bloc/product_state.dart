import 'package:shoes_store/model/product_model.dart';

class AddProductState {}

class AddProductInitialState extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductFailed extends AddProductState {}

class AddProductError extends AddProductState {
  final String errorMessage;

  AddProductError({required this.errorMessage});
}

class UpdateProductState {}

class UpdateProductInitialState extends UpdateProductState {}

class UpdateProductLoading extends UpdateProductState {}

class UpdateProductSuccess extends UpdateProductState {}

class UpdateProductFailed extends UpdateProductState {}

class UpdateProductError extends UpdateProductState {
  final String errorMessage;

  UpdateProductError({required this.errorMessage});
}

class DeleteProductState {}

class DeleteProductInitialState extends DeleteProductState {}

class DeleteProductLoading extends DeleteProductState {}

class DeleteProductSuccess extends DeleteProductState {}

class DeleteProductFailed extends DeleteProductState {}

class DeleteProductError extends DeleteProductState {
  final String errorMessage;

  DeleteProductError({required this.errorMessage});
}

class GetAllProductState {}

class GetAllProductInitialState extends GetAllProductState {}

class GetAllProductLoading extends GetAllProductState {}

class GetAllProductSuccess extends GetAllProductState {
  final List<ProductModel> products;

  GetAllProductSuccess({required this.products});
}

class GetAllProductFailed extends GetAllProductState {}

class GetAllProductError extends GetAllProductState {
  final String errorMessage;

  GetAllProductError({required this.errorMessage});
}

class GetProductByIdState {}

class GetProductByIdInitialState extends GetProductByIdState {}

class GetProductByIdLoading extends GetProductByIdState {}

class GetProductByIdSuccess extends GetProductByIdState {
  final ProductModel product;

  GetProductByIdSuccess({required this.product});
}

class GetProductByIdFailed extends GetProductByIdState {}

class GetProductByIdError extends GetProductByIdState {
  final String errorMessage;

  GetProductByIdError({required this.errorMessage});
}
