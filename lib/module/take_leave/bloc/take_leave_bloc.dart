import 'package:flutter_bloc/flutter_bloc.dart';

import '../../take_leave_list/model/take_list_model.dart';
import '../repo/take_leave_repo.dart';
import 'take_leave_state.dart';

class TakeLeaveCubit extends Cubit<TakeLeaveState> {
  TakeLeaveCubit() : super(TakeLeaveState());
  final TakeLeaveRepo repo = TakeLeaveRepo();

  Future<void> addTakeLeave(TakeListModel item) async {
    try {
      emit(TakeLeaveState(isLoading: true));
      final res = await repo.addTakeLeave(item);
      emit(TakeLeaveState(isSuccess: res, isLoading: false));
    } catch (e) {
      emit(TakeLeaveState(isLoading: false));
      rethrow;
    }
  }
}
