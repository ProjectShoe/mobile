import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_store/model/user_model.dart';
import 'package:shoes_store/module/account/bloc/user_state.dart';
import 'package:shoes_store/module/account/repo/user_repo.dart';

class AddUserCubit extends Cubit<AddUserState> {
  AddUserCubit() : super(AddUserInitialState());
  final UserRepo repo = UserRepo();

  Future<void> addUser(String name, String email, String password) async {
    try {
      emit(AddUserInitialState());
      emit(AddUserLoading());
      final result =
          await repo.addUser(username: name, email: email, password: password);
      if (result == true) {
        emit(AddUserSuccess());
      } else {
        emit(AddUserFailed());
      }
    } catch (e) {
      emit(AddUserError(errorMessage: e.toString()));
    }
  }
}

class UpdateUserCubit extends Cubit<UpdateUserState> {
  UpdateUserCubit() : super(UpdateUserInitialState());
  final UserRepo repo = UserRepo();

  Future<void> updateUser(
      String id, String name, String email, String password) async {
    try {
      emit(UpdateUserInitialState());
      emit(UpdateUserLoading());
      final result = await repo.updateUser(
          id: id, username: name, email: email, password: password);
      if (result == true) {
        emit(UpdateUserSuccess());
      } else {
        emit(UpdateUserFailed());
      }
    } catch (e) {
      emit(UpdateUserError(errorMessage: e.toString()));
    }
  }
}

class DeleteUserCubit extends Cubit<DeleteUserState> {
  DeleteUserCubit() : super(DeleteUserInitialState());
  final UserRepo repo = UserRepo();

  Future<void> deleteUser(String id) async {
    try {
      emit(DeleteUserInitialState());
      emit(DeleteUserLoading());
      final result = await repo.deleteUser(id: id);
      if (result == true) {
        emit(DeleteUserSuccess());
      } else {
        emit(DeleteUserFailed());
      }
    } catch (e) {
      emit(DeleteUserError(errorMessage: e.toString()));
    }
  }
}

class GetAllUserCubit extends Cubit<GetAllUserState> {
  GetAllUserCubit() : super(GetAllUserInitialState());
  final UserRepo repo = UserRepo();

  Future<void> getAllUser() async {
    try {
      emit(GetAllUserInitialState());
      emit(GetAllUserLoading());
      final result = await repo.getAllUser();
      if (result != null) {
        emit(GetAllUserSuccess());
      } else {
        emit(GetAllUserFailed());
      }
    } catch (e) {
      emit(GetAllUserError(errorMessage: e.toString()));
    }
  }
}

class GetUserByIdCubit extends Cubit<GetUserByIdState> {
  GetUserByIdCubit() : super(GetUserByIdInitialState());
  final UserRepo repo = UserRepo();

  Future<void> getUserById(String id) async {
    try {
      emit(GetUserByIdInitialState());
      emit(GetUserByIdLoading());
      final result = await repo.getUserById(id: id);
      if (result != null) {
        final user = UserModel.formJson(result);
        emit(GetUserByIdSuccess(user: user));
      } else {
        emit(GetUserByIdFailed());
      }
    } catch (e) {
      emit(GetUserByIdError(errorMessage: e.toString()));
    }
  }
}
