import 'package:bloc/bloc.dart';
import 'package:conditional_builder_null_safety/example/example.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/blocObserver.dart';
import 'package:socia_app/layout/cubit/cubit.dart';
import 'package:socia_app/layout/cubit/state.dart';
import 'package:socia_app/layout/layout_screen.dart';
import 'package:socia_app/modules/login/login_screen.dart';

import 'sherd/components/constants.dart';
import 'sherd/network/local/cachHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CachHelper.init();
       uId=CachHelper.getData(key:'uId');
  Widget? widget;
  if (uId != null) {
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
            create: (context) => SocialCubit()..getUserData(),
          )
        ],
        child: BlocConsumer<SocialCubit, SocialStates>(
          builder: (context, state) {
            return MaterialApp(

              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Jannah',
                primarySwatch: Colors.blue,
              ),
              home:startScreen ,
            );
          },
          listener: (context, state) {},
        ));
  }
}
