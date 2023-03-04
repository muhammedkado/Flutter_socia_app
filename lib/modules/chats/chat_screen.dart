import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/layout/cubit/cubit.dart';
import 'package:socia_app/layout/cubit/state.dart';
import 'package:socia_app/model/user_model.dart';
import 'package:socia_app/sherd/components/components.dart';

import 'chat_details/chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      builder: (context, state) {
        var cubit= SocialCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.allUser.length>0  ,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => allUser(context,cubit.allUser[index]),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Divider(
                  color: Colors.green,
                ),
              ),
            ),
            itemCount: cubit.allUser.length,
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget allUser(context,UserModel model) => InkWell(
    onTap: (){
      Navigatorto(context: context, Widget: ChatDetailScreen(userModel: model,));
    },
    child : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  '${model.image}',
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                '${model.name}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
  );
}
