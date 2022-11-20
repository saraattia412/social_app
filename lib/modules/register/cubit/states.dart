// ignore_for_file: prefer_typing_uninitialized_variables

abstract class RegisterStates{}

class InitialRegisterStates extends RegisterStates{}

class ChangePasswordVisibilityRegisterState extends RegisterStates{}

class LoadingRegisterState extends RegisterStates{}

class SuccessRegisterState extends RegisterStates{}

class ErrorRegisterState extends RegisterStates{
  late final error;
  ErrorRegisterState({required this.error});
}


class LoadingCreateUserRegisterState extends RegisterStates{}

class SuccessCreateUserRegisterState extends RegisterStates{}

class ErrorCreateUserRegisterState extends RegisterStates{
  late final error;
  ErrorCreateUserRegisterState({required this.error});
}

