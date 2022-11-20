import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/add_post/add_post.dart';
import 'package:social_app/shared/components/navigator.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../edit_profile/edit_profile_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {

    var model =SocialCubit.get(context).model;
    var profileImage= SocialCubit.get(context).profileImage;
    var coverImage= SocialCubit.get(context).coverImage;

    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state){},
      builder: (BuildContext context, Object? state) {

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConditionalBuilder(
              condition: SocialCubit.get(context).model != null,
              builder: (BuildContext context) => Column(
                children: [
                  if(state is ChangeProfileImageSocialStates)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(),
                    ),
                  if(state is ChangeCoverImageSocialStates)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(),
                    ),
                  SizedBox(
                    height: 180,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Container(
                            width: double.infinity,
                            height: 140,
                            decoration:  BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                                image: DecorationImage(
                                  image: coverImage == null
                                      ? NetworkImage(model!.cover!,)
                                      :  FileImage(coverImage) as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(.2),
                              child: IconButton(
                                  onPressed: (){
                                    SocialCubit.get(context)
                                        .getCoverImage(ImageSource.gallery);
                                  },
                                  icon: const Icon(
                                    IconBroken.Camera,
                                    color: Colors.blue,
                                  )
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 64,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Center(
                                child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage:profileImage == null
                                        ? NetworkImage(model!.image!)
                                        :  FileImage(profileImage) as ImageProvider

                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(.2),
                                  child: IconButton(
                                      onPressed: (){
                                        SocialCubit.get(context)
                                            .getProfileImage(ImageSource.gallery);
                                      },
                                      icon: const Icon(
                                        IconBroken.Camera,
                                        color: Colors.blue,
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    model!.name!,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    model.bio!,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '100',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'posts',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            onTap: (){},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '256',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'photos',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            onTap: (){},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '100',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'following',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            onTap: (){},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '10k',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'followers',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            onTap: (){},
                          ),
                        ),

                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Card(
                          color: Colors.blue,
                          child: Container(
                            width: 120,
                            height: 30,
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      IconBroken.Plus
                                  ),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Add Post',
                                    style: TextStyle(
                                        fontSize: 15
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                          navigateTo(context, AddPostScreen());
                        },
                      ),
                      InkWell(
                        child: Card(
                          color: Colors.blue,
                          child: Container(
                            width: 170,
                            height: 30,
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    IconBroken.Edit,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5,),
                                  Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                        fontSize: 15
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                          navigateTo(context, EditProfileScreen());
                        },
                      ),
                      SizedBox(width: 5,),
                      InkWell(
                        child: Card(
                          color: Colors.blue,
                          child: Container(
                            width: 50,
                            height: 30,
                            child: Icon(
                              Icons.more_horiz_outlined,
                              size: 15,
                            ),
                          ),
                        ),
                        onTap: (){
                          navigateTo(context, SettingsScreen());
                        },
                      ),

                    ],
                  ),

                ],
              ),
              fallback: (BuildContext context)
              => Center(child: CircularProgressIndicator()),
            ),

          ),
        );
      },
    );
  }
}
