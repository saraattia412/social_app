import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/search/search_screen.dart';
import 'package:social_app/shared/components/navigator.dart';

import '../modules/add_post/add_post.dart';
import '../modules/chats/chat_screen.dart';
import '../modules/home/home_screen.dart';
import '../modules/notifications/notifications_screen.dart';
import '../modules/profile/profile_screen.dart';
import '../modules/users/users_screen.dart';
import '../shared/styles/icon_broken.dart';



class SocialLayoutScreen extends StatelessWidget {
  const SocialLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {

        return DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              title:  Text(
                  'Social',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [

                IconButton(onPressed: (){
                  navigateTo(context, AddPostScreen());
                }, icon: const Icon(
                    IconBroken.Plus
                )),
                IconButton(onPressed: (){
                  navigateTo(context, const SearchScreen());
                }, icon: const Icon(
                    IconBroken.Search
                )),
                const SizedBox(width: 10,)
              ],
              bottom: TabBar(
                onTap: (index){
                  if(index == 2){
                    SocialCubit.get(context).getAllUsersData();
                  }
                },
                automaticIndicatorColorAdjustment: true,
                labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  tabs:const [
                    Tab(icon:  Icon(IconBroken.Home)),
                    Tab(icon:  Icon(IconBroken.Profile)),
                    Tab(icon:  Icon(IconBroken.Chat)),
                    Tab(icon:  Icon(IconBroken.Notification)),
                    Tab(icon:  Icon(IconBroken.Location)),


                  ]
              ),
            ),
            body: const TabBarView(
             children:[
               HomeScreen(),
               ProfileScreen(),
               ChatScreen(),
               NotificationsScreen(),
               UserScreen(),


             ],

                ),
          ),
        );
      },
    );
  }
}
