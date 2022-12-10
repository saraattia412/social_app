import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/states.dart';
import '../../layout/cubit/cubit.dart';
import '../../models/user_model.dart';

class MessageContainImage extends StatelessWidget {
  final UserModel userModel;
  const MessageContainImage({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(SocialCubit.get(context).messageImage!),
                        fit: BoxFit.fitHeight
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(
                          10),
                    ),
                    child: IconButton(
                        onPressed: () {
                          SocialCubit.get(context)
                              .uploadMessageContainImage(
                            receiverId: userModel.uid!,
                            date: DateTime.now().toString(),

                          );
                          SocialCubit.get(context).messageImage == null;
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 25,
                          color: Colors.white,
                        )
                    ),
                  ),
                ),
              ),
            ],

          ),
        );
      },
    );
  }
}
