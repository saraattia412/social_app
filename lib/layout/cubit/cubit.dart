// ignore_for_file: avoid_print, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/components/constants.dart';

import '../../models/comments_model.dart';
import '../../models/post_model.dart';
import '../../shared/components/toast_package.dart';

class SocialCubit extends Cubit<SocialStates>{
  SocialCubit() : super(InitialSocialStates());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? model;

 void getUserData(){
   emit(LoadingGetUserDataSocialStates());
   FirebaseFirestore.instance.collection('users')
       .doc(uId)
       .get()
   .then((value) {
     print(value.data());
     model=UserModel.formJson(value.data());
     print(model!.email);
     emit(SuccessGetUserDataSocialStates());
   })
   .catchError((error){
     print(error.toString());
     emit(ErrorGetUserDataSocialStates());
   });
 }

  File? profileImage ;
  File? coverImage ;

  Future getProfileImage(ImageSource imageType) async {
    try {
      var photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final image = File(photo.path);
      print(photo.path);
      profileImage = image;
      emit(ChangeProfileImageSocialStates());
      Get.back();
      uploadProfileImage();
    } catch (error) {
      debugPrint(error.toString());
      emit(ErrorChangeProfileImageSocialStates());
    }
  }

  Future<void> uploadProfileImage() async {
    firebase_storage
        .FirebaseStorage.instance
        .ref().child('profile/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('url is $value');
        updateUserData(
            bio: model!.bio!,
            email: model!.email!,
            name: model!.name!,
            phone: model!.phone!,
          profile: value,
        );
        emit(SuccessUpdateProfileSocialStates());
      }).catchError((error) {
        print(error.toString());
      });
    })
        .catchError((error) {
      print(error.toString());
    });
  }


  Future getCoverImage(ImageSource imageType) async {

    try {
      var photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final image = File(photo.path);
      print(photo.path);
      coverImage = image;
      emit(ChangeCoverImageSocialStates());
      Get.back();
      uploadCoverImage();
    } catch (error) {
      debugPrint(error.toString());
      emit(ErrorChangeCoverImageSocialStates());
    }
  }

  Future<void> uploadCoverImage() async {
    firebase_storage
        .FirebaseStorage.instance
        .ref().child('cover/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('url is $value');
        updateUserData(
          bio: model!.bio!,
          email: model!.email!,
          name: model!.name!,
          phone: model!.phone!,
          cover : value,
        );
        emit(SuccessUpdateCoverSocialStates());
      }).catchError((error) {
        print(error.toString());
      });
    })
        .catchError((error) {
      print(error.toString());
    });
  }


  void updateUserData({
  required String bio,
    required String email,
    required String name,
    required String phone,
    String? profile,
    String? cover,

}){
    emit(LoadingUpdateUserDataSocialStates());
     UserModel userModel =UserModel(
      bio: bio,
      email: email,
      name: name,
      phone: phone,
       image: profile ??  model!.image,
       cover: cover ?? model!.cover,
       uid: model!.uid,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uid)
        .update(userModel.toMap())
        .then((value) {
      getUserData();
    }).then((value) {
      showToast(text: 'UPDATE DONE', state: ToastStates.SUCCESS);
    })
        .catchError((error){
      print(error.toString());
      emit(ErrorUpdateUserDataSocialStates());
    });
  }


  File? postImage;

  Future getPostImage(ImageSource imageType) async {

    try {
      var photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final image = File(photo.path);
      print(photo.path);
      postImage = image;
      emit(SuccessGetImagePostSocialStates());
    } catch (error) {
      debugPrint(error.toString());
      emit(ErrorGetImagePostSocialStates());
    }
  }

  void removePostImage(){
    postImage = null;
    emit(RemoveImagePostSocialStates());
  }


  void uploadPostContainImage(
      {
       required String text ,
       required String date ,
      }
      )  {
    emit(LoadingUploadingPostImageSocialStates());
    firebase_storage
        .FirebaseStorage.instance
        .ref().child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('url is $value');
        createPost(
          imagePost: value ,
          date: date,
          text: text,
        );
        emit(SuccessUploadingPostImageSocialStates());
      }).catchError((error) {
        print(error.toString());
        emit(ErrorUploadingPostImageSocialStates());
      });
    })
        .catchError((error) {
      print(error.toString());
      emit(ErrorAddPostSocialStates());
    });

  }


  void createPost({
     required String text ,
     required String date ,
    String? imagePost,
  }){
    emit(LoadingAddPostSocialStates());

    PostModel postModel=PostModel(
      uid: model!.uid,
      postImage: imagePost ?? '',
      name: model!.name,
      image:model!.image,
      text: text ,
      date: date ,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
          emit(SuccessAddPostSocialStates());
    })
        .catchError((error){
      print(error.toString());
      emit(ErrorAddPostSocialStates());
    });
  }


  List<PostModel>? posts= [];
  List<String>? postsId =[];
  List<int>? likes =[];
  List<int>? comment = [];

  void getPosts(){
    emit(LoadingGetPostSocialStates());
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value) {

          value.docs.forEach((element) {

            element.reference
                .collection('comments')
                .get().then((value) {
              comment!.add(value.docs.length);
            }).catchError((error){
              print(error.toString());
            });

            element.reference
            .collection('likes')
            .get().then((value) {
              likes!.add(value.docs.length);
              posts!.add(PostModel.formJson(element.data()));
              postsId!.add(element.id);
              print('posts $posts');
              emit(SuccessGetPostSocialStates());
            }).catchError((error){
              print(error.toString());
            });

          });
        })
    .catchError((error){
      print(error.toString());
      emit(ErrorGetPostSocialStates());
    });
  }

  void likePost(String postId){
    FirebaseFirestore.instance
    .collection('posts')
    .doc(postId)
    .collection('likes')
    .doc(model!.uid)
    .set({
      'like' : true,
    })
    .then((value) {
      emit(SuccessLikePostSocialStates());
    }).catchError((error){
      emit(ErrorLikePostSocialStates());
    });
  }

  void removeLikePost(String postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uid)
        .delete()
        .then((value) {
      emit(SuccessRemoveLikePostSocialStates());
    }).catchError((error){
      emit(ErrorRemoveLikePostSocialStates());
    });
  }

  void commentPost({
    required String postId,
   required String text,
}) {

    CommentModel commentModel=CommentModel(
      name: model!.name,
      profileImage: model!.image,
      commentText: text
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc()
        .set(commentModel.toMap())
        .then((value) {
          print('comment by ${commentModel.name}');
          emit(SuccessCommentPostSocialStates());
    })
        .catchError((error){
          emit(ErrorCommentPostSocialStates());
    });
  }

  List<CommentModel>? commentsData = [];

  void getComments({
    required String postId,
  }){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      commentsData=[];
      event.docs.forEach((element) {
        commentsData!.add(CommentModel.fromJson(element.data()));
        print('comment data $commentsData');
      });
      emit(SuccessGetCommentPostSocialStates());
    });
  }

  List<UserModel> usersData =[];

  void getAllUsersData(){
    if(usersData.length == 0){
      emit(LoadingGetAllUserDataSocialStates());
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) {

          if(element.data()['uid'] != model!.uid)
            usersData.add(UserModel.formJson(element.data()));
            print(usersData);
        });

        emit(SuccessGetAllUserDataSocialStates());
      }).catchError((error){
        print(error.toString());
        emit(ErrorGetAllUserDataSocialStates());
      });

    }


  }


  void sendMessage({
  required String receiverId,
    required String date,
     String? message,
    String? image,

  }){
    MessageModel messageModel = MessageModel(
      date: date,
      message: message,
      receiverId: receiverId,
      senderId: model!.uid,
      imageMessage: image,
    );


    FirebaseFirestore.instance
    .collection('users')
    .doc(model!.uid)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(messageModel.toMap())
    .then((value) {

      emit(SuccessSendMessagesSocialStates());
    })
    .catchError((error){
      print(error.toString());
      emit(ErrorSendMessagesSocialStates());
    });



  FirebaseFirestore.instance
      .collection('users')
      .doc(receiverId)
      .collection('chats')
      .doc(model!.uid)
      .collection('messages')
      .add(messageModel.toMap())
      .then((value) {

  emit(SuccessSendMessagesSocialStates());
  })
      .catchError((error){
  print(error.toString());
  emit(ErrorSendMessagesSocialStates());
  });
}



  File? messageImage;

  Future getMessageImage(ImageSource imageType) async {

    try {
      var photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final image = File(photo.path);
      print(photo.path);
      messageImage = image;
      emit(SuccessImageMessagesSocialStates());
    } catch (error) {
      debugPrint(error.toString());
      emit(ErrorImageMessagesSocialStates());
    }
  }



  void uploadMessageContainImage(
      {
        required String receiverId,
        required String date,
         String? message,
      }
      )  {
    emit(LoadingUploadingImageMessageSocialStates());
    firebase_storage
        .FirebaseStorage.instance
        .ref().child('images_messages/${Uri.file(messageImage!.path).pathSegments.last}')
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('url is $value');
       sendMessage(
           receiverId: receiverId,
           date: date,
           message: message,
         image: value,
       );
        emit(SuccessUploadingImageMessageSocialStates());
      }).catchError((error) {
        print(error.toString());
        emit(ErrorUploadingImageMessageSocialStates());
      });
    })
        .catchError((error) {
      print(error.toString());
      emit(ErrorAddPostSocialStates());
    });

  }



  List<MessageModel> messages =[];

  void getMessages({
  required String receiverId,
}){
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('date')
        .snapshots()
         .listen((event) {
           messages=[];
           event.docs.forEach((element) {
             messages.add(MessageModel.formJson(element.data()));
           });
           emit(SuccessGetMessagesSocialStates());
    });
  }


}