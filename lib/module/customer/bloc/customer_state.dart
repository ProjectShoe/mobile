import 'package:shoes_store/model/customer_model.dart';

class GetAllCustomerState {}

class GetAllCustomerInitialState extends GetAllCustomerState {}

class GetAllCustomerLoading extends GetAllCustomerState {}

class GetAllCustomerSuccess extends GetAllCustomerState {
  final List<CustomerModel> customers;

  GetAllCustomerSuccess({required this.customers});
}

class GetAllCustomerFailed extends GetAllCustomerState {}

class GetAllCustomerError extends GetAllCustomerState {
  final String errorMessage;

  GetAllCustomerError({required this.errorMessage});
}

abstract class AddCustomerState {}

class AddCustomerInitial extends AddCustomerState {}

class AddCustomerLoading extends AddCustomerState {}

class AddCustomerSuccess extends AddCustomerState {}

class AddCustomerFailed extends AddCustomerState {}

class AddCustomerError extends AddCustomerState {
  final String errorMessage;

  AddCustomerError({required this.errorMessage});
}
