import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/take_leave_list_repo.dart';
import 'take_leave_list_state.dart';

class TakeLeaveListCubit extends Cubit<TakeLeaveListState> {
  TakeLeaveListCubit() : super(TakeLeaveListState());
  final TakeLeaveListRepo repo = TakeLeaveListRepo();

  Future<void> getLeaveList() async {
    try {
      emit(TakeLeaveListState(isLoading: true));
      final res = await repo.getTakeLeaveList();
      emit(TakeLeaveListState(
          takeList: res.reversed.toList(), isLoading: false));
    } catch (e) {
      emit(TakeLeaveListState(isLoading: false));
      rethrow;
    }
  }
}
