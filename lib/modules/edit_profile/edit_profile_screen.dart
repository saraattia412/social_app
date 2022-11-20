// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/form_field.dart';

import '../../layout/cubit/cubit.dart';
import '../../shared/components/app_bar_design.dart';

class EditProfileScreen extends StatelessWidget {
   EditProfileScreen({Key? key}) : super(key: key);
  var formKey =GlobalKey<FormState>();
  var emailController =TextEditingController();
  var nameController =TextEditingController();
  var phoneController = TextEditingController();
   var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {

        var model = SocialCubit.get(context).model;
        nameController.text= model!.name!;
        emailController.text=model.email!;
        phoneController.text=model.phone!;
        bioController.text=model.bio!;

        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              title: 'Edit Profile',
              actions: [
                TextButton(
                    onPressed: (){
                      if(formKey.currentState!.validate()){
                        SocialCubit.get(context).
                        updateUserData(bio: bioController.text,
                            email: emailController.text,
                            name: nameController.text,
                            phone: phoneController.text,
                        );
                    }},
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                        color: Colors.blue,

                      ),
                    )
                ),
                SizedBox(width: 5,),
              ]
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if(state is LoadingUpdateUserDataSocialStates)
                      LinearProgressIndicator(),
                    SizedBox(height: 20,),
                    Text(
                      'Bio',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 30,
                      ),
                    ),
                    TextFormField(
                      controller: bioController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Theme.of(context).hintColor,),

                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: defaultFormField(
                        textColor: Theme.of(context).hintColor,
                        colorIcon: Theme.of(context).hintColor,
                        controller: nameController,
                        type: TextInputType.text,
                        validator: (value){
                          if (value!.isEmpty){
                            return 'name must not be null';
                          }
                          return null;
                        },
                        label: 'User Name',
                        prefix: Icons.person,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: defaultFormField(
                        textColor: Theme.of(context).hintColor,
                        colorIcon: Theme.of(context).hintColor,
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validator: (value){
                          if (value!.isEmpty){
                            return 'email address must not be null';
                          }
                          return null;
                        },
                        label: 'Email Address',
                        prefix: Icons.email_outlined,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: defaultFormField(
                        textColor: Theme.of(context).hintColor,
                        colorIcon: Theme.of(context).hintColor,
                        controller: phoneController,
                        type: TextInputType.phone,
                        validator: (value){
                          if (value!.isEmpty){
                            return 'phone number must not be null';
                          }
                          return null;
                        },
                        label: 'Phone Number',
                        prefix: Icons.phone_android,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
