import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_store/module/customer/bloc/customer_state.dart';
import 'package:shoes_store/module/customer/repo/customer_repo.dart';

class GetAllCustomerCubit extends Cubit<GetAllCustomerState> {
  GetAllCustomerCubit() : super(GetAllCustomerInitialState());
  final CustomerRepo repo = CustomerRepo();

  Future<void> getAllCustomer() async {
    try {
      emit(GetAllCustomerInitialState());
      emit(GetAllCustomerLoading());
      final result = await repo.getAllCustomer();
      if (result != null) {
        emit(GetAllCustomerSuccess(customers: result));
      } else {
        emit(GetAllCustomerFailed());
      }
    } catch (e) {
      emit(GetAllCustomerError(errorMessage: e.toString()));
    }
  }
}

class AddCustomerCubit extends Cubit<AddCustomerState> {
  AddCustomerCubit() : super(AddCustomerInitial());
  final CustomerRepo repo = CustomerRepo();

  Future<void> addCustomer(Map<String, dynamic> customerData) async {
    try {
      emit(AddCustomerLoading());
      final success = await repo.addCustomer(customerData);
      if (success) {
        emit(AddCustomerSuccess());
      } else {
        emit(AddCustomerFailed());
      }
    } catch (e) {
      emit(AddCustomerError(errorMessage: e.toString()));
    }
  }
}
