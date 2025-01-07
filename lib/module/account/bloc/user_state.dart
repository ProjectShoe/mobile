import 'package:shoes_store/model/user_model.dart';

class AddUserState {}

class AddUserInitialState extends AddUserState {}

class AddUserLoading extends AddUserState {}

class AddUserSuccess extends AddUserState {}

class AddUserFailed extends AddUserState {}

class AddUserError extends AddUserState {
  final String errorMessage;

  AddUserError({required this.errorMessage});
}

class UpdateUserState {}

class UpdateUserInitialState extends UpdateUserState {}

class UpdateUserLoading extends UpdateUserState {}

class UpdateUserSuccess extends UpdateUserState {}

class UpdateUserFailed extends UpdateUserState {}

class UpdateUserError extends UpdateUserState {
  final String errorMessage;

  UpdateUserError({required this.errorMessage});
}

class DeleteUserState {}

class DeleteUserInitialState extends DeleteUserState {}

class DeleteUserLoading extends DeleteUserState {}

class DeleteUserSuccess extends DeleteUserState {}

class DeleteUserFailed extends DeleteUserState {}

class DeleteUserError extends DeleteUserState {
  final String errorMessage;

  DeleteUserError({required this.errorMessage});
}

class GetAllUserState {}

class GetAllUserInitialState extends GetAllUserState {}

class GetAllUserLoading extends GetAllUserState {}

class GetAllUserSuccess extends GetAllUserState {}

class GetAllUserFailed extends GetAllUserState {}

class GetAllUserError extends GetAllUserState {
  final String errorMessage;

  GetAllUserError({required this.errorMessage});
}

class GetUserByIdState {}

class GetUserByIdInitialState extends GetUserByIdState {}

class GetUserByIdLoading extends GetUserByIdState {}

class GetUserByIdSuccess extends GetUserByIdState {
  final UserModel user;

  GetUserByIdSuccess({required this.user});
}

class GetUserByIdFailed extends GetUserByIdState {}

class GetUserByIdError extends GetUserByIdState {
  final String errorMessage;

  GetUserByIdError({required this.errorMessage});
}
