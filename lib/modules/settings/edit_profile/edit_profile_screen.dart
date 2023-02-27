
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/layout/cubit/cubit.dart';
import 'package:socia_app/layout/cubit/state.dart';
import 'package:socia_app/sherd/components/components.dart';
import 'package:socia_app/sherd/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        nameController.text = cubit.userModel!.name!;
        bioController.text = cubit.userModel!.bio!;
        phoneController.text = cubit.userModel!.phone!;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(IconBroken.Arrow___Left_2)),
            title: const Text('Edit Screen'),
            actions: [
              defaultTextButton(
                  onPressed: () {
                    cubit.updateUserData(
                        name: nameController.text,
                        bio: bioController.text,
                        phone: phoneController.text);
                  },
                  lable: Text(
                    'Update',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.blue, fontSize: 18),
                  )),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  if (state == UpdateUserDataLoadingState)
                    SizedBox(height: 2),
                  if (state == UpdateUserDataLoadingState)
                    LinearProgressIndicator(),
                  if (state == UpdateUserDataLoadingState)
                    SizedBox(height: 2),
                  Container(
                    height: 200,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: cubit.coverImage == null
                                          ? NetworkImage(
                                              '${cubit.userModel!.cover}',
                                            )
                                          : FileImage(cubit.coverImage!)
                                              as ImageProvider,
                                      fit: BoxFit.cover),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.getCoverImage();
                                },
                                icon: const CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: cubit.profileImage == null
                                      ? NetworkImage(
                                          '${cubit.userModel!.image}',
                                        )
                                      : FileImage(cubit.profileImage!)
                                          as ImageProvider),
                            ),
                            IconButton(
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                              icon: const CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (cubit.profileImage != null || cubit.coverImage != null)
                    Row(
                      children: [
                        if (cubit.profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  height: 40,
                                  colors: Colors.green,
                                  text: Text(
                                    'Upload Profile',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                  function: () {
                                    cubit.uploadProfileImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                if (state is UpdateUserprofileImageLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        if (cubit.coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  height: 40,
                                  colors: Colors.green,
                                  text: Text(
                                    'Upload Cover',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                  function: () {
                                    cubit.uploadCoverImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                    );
                                  },
                                ),
                                if (state is UpdateUserCoverImageLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                    lable: 'Name',
                    hintText: 'your name',
                    context: context,
                    controller: nameController,
                    keybord: TextInputType.text,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'name not be empty';
                      }
                      return null;
                    },
                    prefix: IconBroken.User,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                    lable: 'Bio',
                    hintText: 'Write your bio',
                    context: context,
                    controller: bioController,
                    keybord: TextInputType.text,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'Bio not be empty';
                      }
                      return null;
                    },
                    prefix: IconBroken.Info_Circle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                    lable: 'Phone',
                    hintText: 'Write your Phone',
                    context: context,
                    controller: phoneController,
                    keybord: TextInputType.phone,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'Phone not be empty';
                      }
                      return null;
                    },
                    prefix: IconBroken.Call,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
