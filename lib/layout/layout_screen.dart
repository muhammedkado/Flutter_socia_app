import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/layout/cubit/cubit.dart';
import 'package:socia_app/layout/cubit/state.dart';

class SocialLayout extends StatelessWidget {
  SocialLayout({Key? key}) : super(key: key);
  var index = 0;

  @override
  Widget build(BuildContext context) {
    var cubit=SocialCubit.get(context);
    return BlocConsumer<SocialCubit,SocialStates>(
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
                  icon: const Icon(
                    Icons.notifications,
                  ))
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (int index) {
              cubit.changeNavBar(index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'New Project',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_box_outlined,
                ),
                label: 'My project',
              ),
              /*
            BottomNavigationBarItem(
              icon: Icon(
                Icons.send_rounded,
              ),
              label: 'Contact',
              activeIcon: Icon(Icons.send_outlined),
            ),
            */
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: 'Settings',
              ),
            ],
          ),
          body: cubit.screen[cubit.currentIndex],
        );
      },

    );
  }
}
