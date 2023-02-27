import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/layout/cubit/cubit.dart';
import 'package:socia_app/layout/cubit/state.dart';
import 'package:socia_app/modules/new_post/new_post_screen.dart';
import 'package:socia_app/sherd/components/components.dart';
import 'package:socia_app/sherd/styles/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  SocialLayout({Key? key}) : super(key: key);
  var index = 0;

  @override
  Widget build(BuildContext context) {
    var cubit = SocialCubit.get(context);
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 10,
            elevation: 0.2,
            title: Text(cubit.title[cubit.currentIndex]),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  IconBroken.Search,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  IconBroken.Notification,
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (int index) {
              cubit.changeNavBar(index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Chat,
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.User,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(

                icon: Icon(
                  IconBroken.Setting,
                ),
                label: 'Settings',
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(

            onPressed: () {
              Navigatorto(context: context, Widget: NewPostScreen());
            },
            child: Icon(
              IconBroken.Send,
              color: Colors.green,
            ),
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          body: cubit.screen[cubit.currentIndex],
        );
      },
    );
  }
}
