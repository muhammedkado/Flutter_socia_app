import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/layout/cubit/cubit.dart';
import 'package:socia_app/layout/cubit/state.dart';
import 'package:socia_app/sherd/components/components.dart';

class Test1 extends StatelessWidget {
  const Test1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      builder: (context, state) {
        return Scaffold(
            body: ConditionalBuilder(
          condition: SocialCubit.get(context).userModel != null,
          builder: (BuildContext context) {
            var model = SocialCubit.get(context).userModel;
            return Column(
              children: [
                if (!FirebaseAuth.instance.currentUser!.emailVerified)
                  Container(
                    height: 40,
                    color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Icon(Icons.info),
                          const SizedBox(
                            width: 15,
                          ),
                          const Expanded(
                            child: Text(
                              'Pleas Verify Your Email ',
                            ),
                          ),
                          defaultTextButton(
                            onPressed: () {
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification()
                                  .then((value) {
                                    ShowTost(msg: 'Pleas check your email', state: TostState.SUCCESS);
                              })
                                  .catchError((Error) {
                                ShowTost(msg: 'Error${Error.toString()}', state: TostState.ERROR);
                              });
                            },
                            lable: const Text('Send'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
          fallback: (BuildContext context) => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
      },
      listener: (context, state) {},
    );
  }
}
