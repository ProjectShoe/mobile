import 'package:shoes_store/model/order_model.dart';

class AddOrderState {}

class AddOrderInitialState extends AddOrderState {}

class AddOrderLoading extends AddOrderState {}

class AddOrderSuccess extends AddOrderState {}

class AddOrderFailed extends AddOrderState {}

class AddOrderError extends AddOrderState {
  final String errorMessage;

  AddOrderError({required this.errorMessage});
}

class GetAllOrderState {}

class GetAllOrderInitialState extends GetAllOrderState {}

class GetAllOrderLoading extends GetAllOrderState {}

class GetAllOrderSuccess extends GetAllOrderState {
  final List<OrderModel> orders;

  GetAllOrderSuccess({required this.orders});
}

class GetAllOrderFailed extends GetAllOrderState {}

class GetAllOrderError extends GetAllOrderState {
  final String errorMessage;

  GetAllOrderError({required this.errorMessage});
}
