class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailed extends LoginState {}

class LoginError extends LoginState {
  final String errorMessage;

  LoginError({required this.errorMessage});
}
