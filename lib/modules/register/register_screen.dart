// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/navigate_and_finish.dart';
import 'package:social_app/shared/components/navigator.dart';
import 'package:social_app/shared/styles/color.dart';

import '../../layout/layout_screen.dart';
import '../../shared/components/default_button.dart';
import '../../shared/components/form_field.dart';
import '../../shared/components/toast_package.dart';

class RegisterScreen extends StatelessWidget {
   RegisterScreen({Key? key}) : super(key: key);

  var formKey =GlobalKey<FormState>();
  var emailController =TextEditingController();
  var passwordController = TextEditingController();
   var nameController =TextEditingController();
   var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit,RegisterStates>(
          listener: (BuildContext context, state) {
            if(state is SuccessCreateUserRegisterState){
              navigateAndFinish(context, const SocialLayoutScreen());
            }
            if(state is ErrorCreateUserRegisterState){
              showToast(text: state.error.toString().replaceRange(0, 14, '').split(']')[1],
                  state: ToastStates.ERROR);

            }
          },
          builder: (BuildContext context, Object? state) {
            return Scaffold(

                body : Stack(
                  children: [
                    background(),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                          key : formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50,),
                              IconButton(
                                onPressed: () {
                                  navigateTo(context, LoginScreen());
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_sharp,
                                  color: Colors.black,
                                ),),
                              const SizedBox(height: 10,),
                              Center(
                                child: const Text(
                                  'Register',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),

                                ),
                              ),
                              const SizedBox(height: 30,),
                              defaultFormField(
                                controller: nameController,
                                type:TextInputType.text ,
                                validator:(value){
                                  if (value!.isEmpty){
                                    return 'please enter your name';
                                  }
                                  return null;
                                } ,
                                label:'Name' ,
                                prefix: Icons.person,
                                onSubmit: (value){
                                  TextInputAction.done;
                                },

                              ),
                              const SizedBox(height: 20,),
                              defaultFormField(
                                controller: emailController,
                                type:TextInputType.emailAddress ,
                                validator:(value){
                                  if (value!.isEmpty){
                                    return 'please enter your email address';
                                  }
                                  return null;
                                } ,
                                label:'Email Address' ,
                                prefix: Icons.email_outlined,
                                onSubmit: (value){
                                  TextInputAction.done;
                                },

                              ),
                              const SizedBox(height: 20,),
                              defaultFormField(
                                controller: phoneController,
                                type:TextInputType.phone ,
                                validator:(value){
                                  if (value!.isEmpty){
                                    return 'please enter your phone';
                                  }
                                  return null;
                                } ,
                                label:'Phone Number' ,
                                prefix: Icons.phone_android,
                                onSubmit: (value){
                                  TextInputAction.done;
                                },

                              ),
                              const SizedBox(height: 20,),
                              defaultFormField(
                                controller: passwordController,
                                type: TextInputType.visiblePassword,
                                validator: ( value){
                                  if (value!.isEmpty){
                                    return 'Password Is Too Short';
                                  }
                                  return null;
                                } ,
                                label: 'Password',
                                prefix: Icons.lock_outlined,
                                isPassword: RegisterCubit.get(context).isPassword,
                                suffix: RegisterCubit.get(context).suffix,
                                suffixPressed: (){//الدوسه
                                  RegisterCubit.get(context).changePasswordVisibility();
                                },
                                onSubmit: (value){
                                  TextInputAction.done;
                                },
                              ),
                              const SizedBox(height: 30,),
                              ConditionalBuilder(
                                condition: state is! LoadingRegisterState,
                                builder: (BuildContext context) => defaultButton(
                                  function: (){
                                    if(formKey.currentState!.validate()){
                                      RegisterCubit.get(context).usersRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        password: passwordController.text,
                                      );
                                    }

                                  },
                                  text: 'register',
                                  isUpperCase: true,
                                ),
                                fallback:(context) => const Center(child: CircularProgressIndicator()),
                              ),
                              const SizedBox(height: 15,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            );
          },
            )
    );
  }
}
