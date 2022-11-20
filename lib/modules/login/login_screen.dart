// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/layout_screen.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/shared/components/form_field.dart';
import 'package:social_app/shared/components/navigate_and_finish.dart';
import 'package:social_app/shared/components/toast_package.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/color.dart';

import '../../shared/components/default_button.dart';
import '../../shared/components/navigator.dart';
import '../register/register_screen.dart';
import 'cubit/cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var formKey =GlobalKey<FormState>();
  var emailController =TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (BuildContext context, state) {
          if(state is ErrorLoginStates){
            showToast(text: state.error.toString().replaceRange(0, 14, '').split(']')[1],
                state: ToastStates.ERROR);
          }
          if(state is SuccessLoginStates){
            CacheHelper.saveData(
                key: 'uid',
                value: state.uid,
            ).then((value) {
              navigateAndFinish(context, const SocialLayoutScreen());
            });
          }
        },
        builder: (BuildContext context, Object? state) {
          return
            Scaffold(
              body: Stack(children: [
                background(),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key : formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                        const SizedBox(height: 30,),
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
                          isPassword: LoginCubit.get(context).isPassword,
                          suffix: LoginCubit.get(context).suffix,
                          suffixPressed: (){//الدوسه
                            LoginCubit.get(context).changePasswordVisibility();
                          },
                          onSubmit: (value){
                            TextInputAction.done;
                          },
                        ),
                        const SizedBox(height: 30,),
                        ConditionalBuilder(
                          condition: state is! LoadingLoginStates,
                          builder: (BuildContext context) => defaultButton(
                            function: (){
                              if(formKey.currentState!.validate()){
                                LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text
                                );
                              }

                            },
                            text: 'login',
                            isUpperCase: true,
                          ),
                          fallback:(context) => const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Text(
                                'don\'t have account?  ',
                              style: TextStyle(
                                  color: Colors.black

                              ),
                            ),
                            TextButton(onPressed: (){
                              navigateTo(context,  RegisterScreen());
                            }, child:  const Text(
                              'register now!',
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],)
          );
        },
      ),
    );
  }
}
