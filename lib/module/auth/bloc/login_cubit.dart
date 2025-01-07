import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_store/module/auth/bloc/login_state.dart';
import 'package:shoes_store/module/auth/repo/login_repo.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());
  final LoginRepo repo = LoginRepo();
  Future<void> login(String email, String password) async {
    try {
      emit(LoginInitialState());
      emit(LoginLoading());
      final result = await repo.login(email: email, password: password);
      if (result == true) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailed());
      }
    } catch (e) {
      emit(LoginError(errorMessage: e.toString()));
    }
  }
}
