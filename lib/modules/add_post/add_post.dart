// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../../shared/components/app_bar_design.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var model = SocialCubit.get(context).model;
    var postImage = SocialCubit.get(context).postImage;

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        return GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: defaultAppBar(context: context, title: 'Add Post', actions: [
              TextButton(
                  onPressed: () {

                    if(formKey.currentState!.validate()){
                      if (SocialCubit.get(context).postImage == null) {
                        SocialCubit.get(context).createPost(
                            date: DateTime.now().toString(),
                            text: postController.text);
                      } else {
                        SocialCubit.get(context).uploadPostContainImage(
                            date: DateTime.now().toString(),
                            text: postController.text);

                      }
                      postController.text='';
                  }},
                  child: Text(
                    'POST',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    ),
                  ))
            ]),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          if (state is LoadingAddPostSocialStates)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LinearProgressIndicator(),
                            ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(model!.image!),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.name!,
                                      style: TextStyle(fontSize: 25, height: 1),
                                    ),
                                    Text(
                                      DateTime.now().toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: postController,
                            decoration: InputDecoration(
                                hintText: 'What\'s on your mind?... ',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                                border: InputBorder.none),
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            maxLength: 200,
                            maxLines: 5,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'What\'s on your mind?';
                              }
                              return null;
                            },
                          ),
                          if (postImage != null)
                            Stack(
                              alignment: AlignmentDirectional.topStart,
                              children: [
                                Container(
                                  height: 140,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                          image: FileImage(postImage),
                                          fit: BoxFit.cover)),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(.6),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        SocialCubit.get(context).removePostImage();
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      )),
                                ),
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: .3,
                    minChildSize: .1,
                    maxChildSize: .4,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        width: double.infinity,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListView(
                          controller: scrollController,
                          children: [
                           Container(
                             decoration: BoxDecoration(
                               border: Border.symmetric(
                                 horizontal: BorderSide(color: Colors.grey)
                               )
                             ),
                             child: Row(
                               children: [
                                 Icon(IconBroken.Image),
                                 TextButton(
                                     onPressed: () {
                                       SocialCubit.get(context).getPostImage(ImageSource.gallery);
                                     }, child: Text('Photo')),
                               ],
                             ),
                           ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey)
                                  )
                              ),
                              child: Row(
                                children: [
                                  Icon(IconBroken.Camera),
                                  TextButton(
                                      onPressed: () {
                                        SocialCubit.get(context).getPostImage(ImageSource.camera);
                                      }, child: Text('Camera')),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey)
                                  )
                              ),
                              child: Row(
                                children: [
                                  Icon(IconBroken.User),
                                  TextButton(
                                      onPressed: () {}, child: Text('# tags')),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey)
                                  )
                              ),
                              child: Row(
                                children: [
                                  Icon(IconBroken.Location),
                                  TextButton(
                                      onPressed: () {}, child: Text('check in')),
                                ],
                              ),
                            ),

                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
