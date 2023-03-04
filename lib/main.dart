import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/blocObserver.dart';
import 'package:socia_app/layout/cubit/cubit.dart';
import 'package:socia_app/layout/cubit/state.dart';
import 'package:socia_app/layout/layout_screen.dart';
import 'package:socia_app/modules/login/login_screen.dart';
import 'package:socia_app/sherd/components/components.dart';

import 'sherd/components/constants.dart';
import 'sherd/network/local/cachHelper.dart';
import 'sherd/styles/thememod.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print(message.data.toString());
  ShowTost(msg: 'on background messages', state: TostState.SUCCESS);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  var Token = await FirebaseMessaging.instance.getToken();
   print(Token);
  await messaging.requestPermission();

  FirebaseMessaging.onMessage.listen((event) {
    print('=>>>---${event.data.toString()}');
    ShowTost(msg: 'onMessage', state: TostState.SUCCESS);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) { 
    print(event.data.toString());
    ShowTost(msg: 'onMessageOpenedApp', state: TostState.SUCCESS);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  await CachHelper.init();
  uId = CachHelper.getData(key: 'uId');
  Widget? widget;
  if (uId != null) {
    uId = CachHelper.getData(key: 'uId');
    widget = SocialLayout();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(
    startScreen: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => SocialCubit()
                ..getUserData()
                ..getPosts())
        ],
        child: BlocConsumer<SocialCubit, SocialStates>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              darkTheme: darkTheme,
              themeMode: ThemeMode.dark,
              theme: lightTheme,
              home: startScreen,
            );
          },
          listener: (context, state) {},
        ));
  }
}
