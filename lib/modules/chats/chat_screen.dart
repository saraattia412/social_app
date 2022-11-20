import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_details_screen.dart';
import 'package:social_app/shared/components/line.dart';
import 'package:social_app/shared/components/navigator.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).usersData.isNotEmpty,
          builder: (BuildContext context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index) => chatDesign(SocialCubit.get(context).usersData[index],context),
              separatorBuilder: (context,index) => myDivider(),
              itemCount: SocialCubit.get(context).usersData.length
          ), fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),

        );
      },

    );
  }


  Widget chatDesign(UserModel model,context)  =>  InkWell(
    onTap: (){
      navigateTo(context, ChatDetailsScreen(userModel: model,));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:  [
          CircleAvatar(
            radius: 25.0,
            backgroundImage:
            NetworkImage(
                model.image!
            ),
          ),
          const SizedBox(width: 15,),
          Text(
            model.name!,
            style: TextStyle(
              fontSize: 20,
            ),
          ),

        ],
      ),
    ),
  );
}
