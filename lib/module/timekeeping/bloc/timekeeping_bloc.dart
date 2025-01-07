import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/timekeeping_model.dart';
import '../repo/timekeeping_repo.dart';
import 'timekeeping_state.dart';

class TimeKeepingCubit extends Cubit<TimeKeepingState> {
  TimeKeepingCubit() : super(TimeKeepingState());
  final TimeKeepingRepo repo = TimeKeepingRepo();

  void addTimeKeeping(TimeKeepingModel item) async {
    try {
      emit(TimeKeepingState(isLoading: true, message: ''));
      final localIp = await getLocalIpAddress();
      print(localIp);
      if (localIp != '172.20.10.2') {
        emit(TimeKeepingState(isLoading: false, message: 'Sai địa chỉ mạng'));
        return;
      }
      final res = await repo.addTimeKeeping(item);
      emit(TimeKeepingState(isLoading: false, message: res));
    } catch (e) {
      emit(TimeKeepingState(isLoading: false));
      rethrow;
    }
  }

  Future<String?> getLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4, includeLinkLocal: true);

    try {
      NetworkInterface vpnInterface =
          interfaces.firstWhere((element) => element.name == "tun0");
      return vpnInterface.addresses.first.address;
    } on StateError {
      try {
        NetworkInterface interface =
            interfaces.firstWhere((element) => element.name == "wlan0");
        return interface.addresses.first.address;
      } catch (ex) {
        try {
          NetworkInterface interface = interfaces.firstWhere((element) =>
              !(element.name == "tun0" || element.name == "wlan0"));
          return interface.addresses.first.address;
        } catch (ex) {
          return null;
        }
      }
    }
  }
}

class TimeMyKeepingCubit extends Cubit<TimeMyKeepingState> {
  TimeMyKeepingCubit() : super(TimeMyKeepingInitialState());
  final TimeKeepingRepo repo = TimeKeepingRepo();

  Future<void> getTimeMyKeeping() async {
    try {
      emit(TimeMyKeepingInitialState());
      emit(TimeMyKeepingLoadingState());
      final result = await repo.getMyTimeKeeping();
      if (result != null && result.isNotEmpty) {
        emit(TimeMyKeepingSuccessState(timeMyKeepingList: result));
      } else {
        emit(TimeMyKeepingFailedState());
      }
    } catch (e) {
      emit(TimeMyKeepingErrorState(errorMessage: e.toString()));
    }
  }
}
