// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/layout_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/components/toast_package.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/theme.dart';

import 'modules/login/login_screen.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print('on background data ');
  print(message.data.toString());
}
// BJFDbyGkHWHBUFQelhrK7Hnqt82_hDTQ26T8FxPwYA4LdioBwJIh5WrPY-F9IeW66zr428mLr-UJOLKZMR-3bl0
void main()async
{

  //بيتاكد ان كل حاجه ف الميثود هنا خلصت وبعدين يفتح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();//import use with async
  await Firebase.initializeApp();
  // await FirebaseAppCheck.instance.activate();
  // await FirebaseAppCheck.instance.getToken();
  var token =await FirebaseMessaging.instance.getToken();
  print('token is $token');
  await FirebaseAppCheck.instance.getToken();

  FirebaseMessaging.onMessage.listen((event) {
    print('on message  app');
    print(event.data.toString());
    showToast(text: 'on message', state: ToastStates.SUCCESS);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');
    print(event.data.toString());
    showToast(text: 'on message opened', state: ToastStates.SUCCESS);

  });


  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getBooleanData(key: 'isDark');
  Widget widget;
  uId=CacheHelper.getData(key: 'uid');

  if(uId != null){
    widget = SocialLayoutScreen();
  }else{
    widget=LoginScreen();
  }

  runApp(MyApp(
    startWidget: widget,isDark: isDark,));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final  startWidget;
  const MyApp({Key? key,required this.startWidget,  this.isDark}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return  MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => SocialCubit()..getUserData()..getPosts()..getAllUsersData()
        ),
        BlocProvider(
          create: (context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, state) {  },
        builder: (BuildContext context, Object? state) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home:startWidget,


          );
        },
      ),
    );
  }
}

