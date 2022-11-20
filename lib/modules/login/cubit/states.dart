// ignore_for_file: prefer_typing_uninitialized_variables

abstract class LoginStates{}

class InitialLoginStates extends LoginStates{}

class ChangePasswordVisibilityLogInState extends LoginStates{}

class LoadingLoginStates extends LoginStates{}

class SuccessLoginStates extends LoginStates{
  late final uid;
  SuccessLoginStates({required this.uid});
}

class ErrorLoginStates extends LoginStates{
  late final error;
  ErrorLoginStates({required this.error});
}
