// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/modules/chats/show_image_from_chat.dart';
import 'package:social_app/shared/components/navigator.dart';

import '../../models/user_model.dart';
import 'MessageContainImage.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel userModel;
  ChatDetailsScreen({Key? key, required this.userModel}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.uid!);

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (BuildContext context, state) {},
          builder: (BuildContext context, Object? state) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: AppBar(
                  titleSpacing: 0.0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(
                          userModel.image!,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        userModel.name!,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                body: ConditionalBuilder(
                  condition: SocialCubit.get(context).messages.length >= 0,
                  builder: (BuildContext context) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                var message =
                                    SocialCubit.get(context).messages[index];
                                if (SocialCubit.get(context).model!.uid! ==
                                    message.senderId) {
                                  return buildMyMessageDesign(message, context);
                                }
                                return buildMessageDesign(message, context);
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 10,
                                  ),
                              itemCount:
                                  SocialCubit.get(context).messages.length),
                        ),
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    SocialCubit.get(context)
                                        .getMessageImage(ImageSource.gallery)
                                        .then((value) {
                                      navigateTo(
                                          context,
                                          MessageContainImage(
                                            userModel: userModel,
                                          ));
                                    });
                                  },
                                  child: Icon(
                                    Icons.image_rounded,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 2.0, color: Colors.grey),
                                      ),
                                      fillColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      hintText: 'type your message...',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        height: .9),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          SocialCubit.get(context).sendMessage(
                                            receiverId: userModel.uid!,
                                            date: DateTime.now().toString(),
                                            message: messageController.text,
                                          );
                                          messageController.text = '';
                                        }
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 25,
                                        color: Colors.white,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  fallback: (BuildContext context) =>
                      Center(child: CircularProgressIndicator()),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessageDesign(MessageModel model, context) => Column(
        children: [
          if (model.message != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(10),
                    topEnd: Radius.circular(10),
                    topStart: Radius.circular(10),
                  ),
                ),
                child: Text(
                  model.message!,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          if (model.imageMessage != null)
            InkWell(
              onTap: () {
                navigateTo(context, ShowImage(image: model.imageMessage!));
              },
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(10),
                      topEnd: Radius.circular(10),
                      topStart: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 250,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(model.imageMessage!),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(10),
                          topEnd: Radius.circular(10),
                          topStart: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );

  Widget buildMyMessageDesign(MessageModel model, context) => Column(
        children: [
          if (model.message != null)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(.3),
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(10),
                          topStart: Radius.circular(10),
                          bottomStart: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            model.message!,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          if (model.imageMessage != null)
            InkWell(
              onTap: () {
                navigateTo(context, ShowImage(image: model.imageMessage!));
              },
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.3),
                    borderRadius: BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(10),
                      topEnd: Radius.circular(10),
                      topStart: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 250,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(model.imageMessage!),
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(10),
                          topStart: Radius.circular(10),
                          bottomStart: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
}
