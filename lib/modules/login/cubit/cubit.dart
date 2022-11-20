

// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/states.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit() : super(InitialLoginStates());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData suffix=Icons.visibility_off_outlined;
  bool isPassword=true;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix=isPassword ? Icons.visibility_off_outlined  : Icons.visibility_outlined;
    emit(ChangePasswordVisibilityLogInState());

  }

  void userLogin(
  {
  required String email,
    required String password,

  }
      ){
    emit(LoadingLoginStates());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      emit(SuccessLoginStates(uid: value.user!.uid));
    }).catchError((error){
      emit(ErrorLoginStates(error: error.toString()));
    });

  }


}