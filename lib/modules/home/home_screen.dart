// ignore_for_file: sized_box_for_whitespace

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/add_post/add_post.dart';
import 'package:social_app/modules/comments/comments_screen.dart';
import 'package:social_app/shared/components/navigator.dart';

import '../../shared/styles/icon_broken.dart';


class HomeScreen extends StatelessWidget {
   const HomeScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts!.length > 0
              && SocialCubit.get(context).model != null,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          bottom: 20,
                          start: 10,
                          top: 10
                      ),
                      child: Row(
                        children:  [
                           CircleAvatar(
                            radius: 15.0,
                            backgroundImage:
                            NetworkImage(
                                SocialCubit.get(context).model!.image!,
                            ),
                          ),
                          const SizedBox(width: 10,),
                          InkWell(
                            child: Container(
                                width: 300,
                                height: 40,
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: HexColor('#e6e6e6'),
                                      width: 1
                                  ),
                                ) ,
                                child:  Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        IconBroken.Edit,
                                        size: 15,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        'what\'s on your mind? ',
                                        style: TextStyle(
                                            fontSize: 12
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                            onTap:(){
                              navigateTo(context, AddPostScreen());
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index) =>
                        buildPostItem(context,SocialCubit.get(context).posts![index],index),
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10,),
                    itemCount: SocialCubit.get(context).posts!.length,
                  ),
                  const SizedBox(height: 8,),
                ],
              ),
            );
          },
          fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }


  Widget buildPostItem(context,PostModel postModel,index) => Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5,
    margin: const EdgeInsets.symmetric(
        horizontal: 8.0
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children:  [
               CircleAvatar(
                radius: 25.0,
                backgroundImage:
                NetworkImage(
                  postModel.image!
                ),
              ),
              const SizedBox(width: 15,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Row(
                      children:  [
                        Text(
                          postModel.name!,
                          style: TextStyle(
                              height: 1.4
                          ),
                        ),
                        SizedBox(width: 5,),
                        Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 16,
                        )
                      ],
                    ),
                     Text(
                      postModel.date!,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          height: 1.4
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(width: 15,),
              IconButton(onPressed: (){},
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 16.0,
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
           Text(
             postModel.text!,
           style: TextStyle(
              fontSize: 14,
              height: 1.2
          ),
          ),
          if(postModel.postImage != '')
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  top: 15
              ),
              child: Container(
                width: double.infinity,
                height: 140,
                decoration:   BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image:  DecorationImage(
                      image: NetworkImage(
                          postModel.postImage!),
                      fit: BoxFit.cover,
                    )
                ),

              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 5
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5
                      ),
                      child: Row(
                        children:  [
                          Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                            size: 16,
                          ),
                          SizedBox(width: 5,),
                          Text(
                           ' ${SocialCubit.get(context).likes![index]}' ,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:  [
                          Icon(
                            IconBroken.Chat,
                            color: Colors.amber,
                            size: 16,
                          ),
                          SizedBox(width: 5,),
                          Text(
                            '${SocialCubit.get(context).comment![index]} comments',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 10
            ),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    children:   [
                      CircleAvatar(
                        radius: 15.0,
                        backgroundImage:
                        NetworkImage(
                          SocialCubit.get(context).model!.image!,
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text(
                        'write a comment..',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            height: 1.4
                        ),
                      ),
                    ],
                  ),
                  onTap: (){
                     navigateTo(context, CommentsScreen(index: index,));
                  },
                ),
              ),
              InkWell(
                child: Row(
                  children:  [
                    Icon(
                      IconBroken.Heart,
                      color: Colors.red,
                      size: 16,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      'like',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    ),
                  ],
                ),
                onTap: (){
                  SocialCubit.get(context).likePost(SocialCubit.get(context).postsId![index]);
                },
              ),
            ],

          ),

        ],
      ),
    ),
  );
}
