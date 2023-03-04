import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/layout/cubit/cubit.dart';
import 'package:socia_app/layout/cubit/state.dart';
import 'package:socia_app/model/messages_model.dart';
import 'package:socia_app/model/user_model.dart';
import 'package:socia_app/sherd/styles/icon_broken.dart';

class ChatDetailScreen extends StatelessWidget {
  UserModel? userModel;

  ChatDetailScreen({Key? key, this.userModel}) : super(key: key);
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receiverId: userModel!.uId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      IconBroken.Arrow___Left_2,
                      size: 25,
                    )),
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('${userModel!.image}'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text('${userModel!.name}')
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          reverse: true,
                          itemBuilder: (context, index) {
                            var message = cubit.message[index];
                            if (cubit.userModel!.uId == message.receiverId) {
                              return Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    right: 100,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: const BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius:
                                          BorderRadiusDirectional.only(
                                        topEnd: Radius.circular(10),
                                        topStart: Radius.circular(10),
                                        bottomEnd: Radius.circular(10),
                                      )),
                                  child:
                                      Text(
                                        '${message.text}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18),
                                      ),


                                ),
                              );
                            } else {
                              return Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Column(
                                  children: [

                                    Container(
                                      // width: 300,
                                      margin: const EdgeInsets.only(
                                        left: 100,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadiusDirectional.only(
                                            topEnd: Radius.circular(10),
                                            topStart: Radius.circular(10),
                                            bottomStart: Radius.circular(10),
                                          )),
                                      child: Text(
                                        '${message.text}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                          itemCount: cubit.message.length,
                        ),
                      ),
                      if(cubit.chatImage != null)
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:FileImage(cubit.chatImage!),
                                  fit: BoxFit.cover),
                              borderRadius:BorderRadius.circular(4)
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300]!, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Container(
                              color:Colors.green,
                                child: IconButton(
                              onPressed: () {
                                cubit.dialogBuilder(context);
                              },
                              icon: const Icon(
                                IconBroken.Camera,
                                color: Colors.white,
                                size: 25,
                              ),
                            )),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  controller: messageController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type your message here ...',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 60,
                              color: Colors.green,
                              child: MaterialButton(
                                  onPressed: () {
                                    cubit.sendMessages(
                                      text: messageController.text,
                                      sederId: cubit.userModel!.uId!,
                                      receiverId: userModel!.uId!,
                                      dateTime: DateTime.now().toString(),
                                      aftermessage: messageController,
                                    );
                                  },
                                  child: const Icon(
                                    IconBroken.Send,
                                    color: Colors.white,
                                    size: 25,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
          listener: (context, state) {},
        );
      },
    );
  }

  Widget buildMessage(BuildContext context, MessagesModel messagesModel) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadiusDirectional.only(
                topEnd: Radius.circular(10),
                topStart: Radius.circular(10),
                bottomEnd: Radius.circular(10),
              )),
          child: Text(
            '${messagesModel.text}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ),
      );

  Widget buildMyMessage(BuildContext context, MessagesModel messagesModel) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.green[300],
              borderRadius: const BorderRadiusDirectional.only(
                topEnd: Radius.circular(10),
                topStart: Radius.circular(10),
                bottomStart: Radius.circular(10),
              )),
          child: Text(
            '${messagesModel.text}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ),
      );


}
