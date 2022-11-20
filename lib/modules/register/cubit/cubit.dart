// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/cubit/states.dart';

import '../../../models/user_model.dart';

class RegisterCubit extends Cubit<RegisterStates>{
  RegisterCubit() : super(InitialRegisterStates());

  static RegisterCubit get(context) => BlocProvider.of(context);

  IconData suffix=Icons.visibility_off_outlined;
  bool isPassword=true;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix=isPassword ? Icons.visibility_off_outlined  : Icons.visibility_outlined;
    emit(ChangePasswordVisibilityRegisterState());

  }


  void usersRegister(
  {
  required String name,
    required String email,
    required String phone,
    required String password,

  }
      ){
    emit(LoadingRegisterState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      emit(SuccessRegisterState());
      createUser(
          uid: value.user!.uid,
          name: name,
          email: email,
          phone: phone
      );
    }).catchError((error){
      emit(ErrorRegisterState(error: error.toString()));
    });

  }



  void createUser(
      {
        required String uid,
        required String name,
        required String email,
        required String phone,

      }
      ){
    emit(LoadingCreateUserRegisterState());
    UserModel model =UserModel(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
        image: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
        bio: 'hey there! i am using social',
      cover: 'https://cdn.wallpapersafari.com/39/72/MF1esV.jpg',

    );

    FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .set(model.toMap())
        .then((value) {
          emit(SuccessCreateUserRegisterState());
    }).catchError((error){
      emit(ErrorCreateUserRegisterState(error: error.toString()));
    });

  }


}