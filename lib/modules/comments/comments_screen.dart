// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';

import '../../models/comments_model.dart';
import '../../shared/styles/icon_broken.dart';

class CommentsScreen extends StatelessWidget {
  final  index;
   CommentsScreen({Key? key, required this.index}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {

        SocialCubit.get(context).getComments(postId: SocialCubit.get(context).postsId![index]);

        return BlocConsumer<SocialCubit,SocialStates>(
          listener: (BuildContext context, state) {  },
          builder: (BuildContext context, Object? state) {
            return Scaffold(
              body:  ConditionalBuilder(
                condition: true,
                builder: (BuildContext context) =>  Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index) {
                          var model = SocialCubit.get(context).commentsData![index];
                          return commentDesign(model, context);
                        },
                        separatorBuilder: (context,index) => SizedBox(height: 10,),
                        itemCount: SocialCubit.get(context).commentsData!.length
                    ),
                  ),

                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: commentController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(width: 2.0,color: Colors.grey),
                                ),
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                hintText: 'type your comment...',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                height: .9,
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return '';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 5,),
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                                onPressed: (){
                                  if(formKey.currentState!.validate()){
                                    SocialCubit.get(context).commentPost
                                      (
                                        postId: SocialCubit.get(context).postsId![index],
                                        text: commentController.text,
                                    );
                                }},
                                icon: Icon(
                                  IconBroken.Send,
                                  size: 25,
                                  color: Colors.white,
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

                fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),

              ),
            );
          },

        );
      },

    );
  }


  Widget commentDesign(CommentModel commentModel,context) =>  Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:   [
        CircleAvatar(
          radius: 30.0,
          backgroundImage:
          NetworkImage(
            commentModel.profileImage!,
          ),
        ),
        SizedBox(width: 15,),
        Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commentModel.name!,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).hintColor,
                      height: 1
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  commentModel.commentText!,
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),


              ],
            ),
          )
        ),
      ],
    ),
  );
}
