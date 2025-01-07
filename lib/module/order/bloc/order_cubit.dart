import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_store/module/order/bloc/order_state.dart';
import 'package:shoes_store/module/order/repo/order_repo.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  AddOrderCubit() : super(AddOrderInitialState());
  final OrderRepo repo = OrderRepo();

  Future<void> addOrder(Map<String, dynamic> data) async {
    try {
      emit(AddOrderInitialState());
      emit(AddOrderLoading());
      final result = await repo.addOrder(data: data);
      if (result == true) {
        emit(AddOrderSuccess());
      } else {
        emit(AddOrderFailed());
      }
    } catch (e) {
      emit(AddOrderError(errorMessage: e.toString()));
    }
  }
}

class GetAllOrderCubit extends Cubit<GetAllOrderState> {
  GetAllOrderCubit() : super(GetAllOrderInitialState());
  final OrderRepo repo = OrderRepo();

  Future<void> getAllOrder() async {
    try {
      emit(GetAllOrderInitialState());
      emit(GetAllOrderLoading());
      final result = await repo.getAllOrder();
      if (result != null) {
        emit(GetAllOrderSuccess(orders: result));
      } else {
        emit(GetAllOrderFailed());
      }
    } catch (e) {
      emit(GetAllOrderError(errorMessage: e.toString()));
    }
  }
}
