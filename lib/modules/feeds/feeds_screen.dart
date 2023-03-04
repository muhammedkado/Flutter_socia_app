import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/layout/cubit/cubit.dart';
import 'package:socia_app/layout/cubit/state.dart';
import 'package:socia_app/model/post_model.dart';
import 'package:socia_app/sherd/styles/icon_broken.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      builder: (context, state) {
        var cubit =SocialCubit.get(context);
        return ConditionalBuilder(
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  margin: const EdgeInsets.all(8),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 10,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      const Image(
                        image: NetworkImage(
                          'https://img.freepik.com/free-photo/cheerful-caucasian-girl-keeps-hands-together-near-face-looks-positively-aside-has-no-make-up-healthy-skin-wears-white-sweater-stands-purple-wall-with-blank-space-your-promotion_273609-26101.jpg?w=1060&t=st=1677340569~exp=1677341169~hmac=a70cc37ce2054d89d6da7de97de61231341faf257173dde4156244b6766286a6',
                        ),
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('communicate with friends',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => buildPostItem(cubit.post[index],context,index),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
                  itemCount: cubit.post.length,
                ),
                const SizedBox(height: 15,)
              ],
            ),
          ),
          condition:cubit.post.length>0 && cubit.userModel !=null,
          fallback: (context) => const Center(child: CircularProgressIndicator(),),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget buildPostItem(PostModel postModel,context,index) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                      '${postModel.image}',
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${postModel.name}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 18,
                            )
                          ],
                        ),
                        Text(
                          '${postModel.time}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(IconBroken.More_Circle),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                '${postModel.text}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              /*
              Container(
               // padding: const EdgeInsets.symmetric(vertical: 1),
                width: double.infinity,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 6),
                      child: SizedBox(
                        height: 20,
                        child: MaterialButton(
                          onPressed: () {},
                          minWidth: 1.0,
                          padding: EdgeInsets.zero,
                          child: Text(
                            '#Software',
                            style:
                            Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 10),
                      child: Container(
                        height: 20,
                        child: MaterialButton(
                          onPressed: () {},
                          minWidth: 1.0,
                          padding: EdgeInsets.zero,
                          child: Text(
                            '#Flutter',
                            style:
                            Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

               */
              if(postModel.postImage!='')
                Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      image:   DecorationImage(
                        image: NetworkImage(
                          '${postModel.postImage}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {

                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              const Icon(
                                IconBroken.Heart,
                                size: 16,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${SocialCubit.get(context).likes[index]}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          SocialCubit.get(context).commentPostCount(SocialCubit.get(context).postId[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                IconBroken.Chat,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${SocialCubit.get(context).comments[index]} comment',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 5,
                ),
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            CircleAvatar(
                            radius: 18.0,
                            backgroundImage: NetworkImage(
                              '${SocialCubit.get(context).userModel!.image}',
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'write a comment..',
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      SocialCubit.get(context).likePost( SocialCubit.get(context).postId[index]);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          IconBroken.Heart,
                          size: 25,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Like',
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
