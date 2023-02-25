import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/layout/layout_screen.dart';
import 'package:socia_app/modules/login/cubit/cubit.dart';
import 'package:socia_app/modules/login/cubit/states.dart';
import 'package:socia_app/modules/register/register_screen.dart';
import 'package:socia_app/sherd/components/components.dart';

import '../../sherd/components/constants.dart';
import '../../sherd/network/local/cachHelper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        builder: (context, state) {
          return Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                        child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LOGIN',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 35),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Login now',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          defaultFormField(
                              context: context,
                              prefix: Icons.email_outlined,
                              controller: emailController,
                              keybord: TextInputType.emailAddress,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Email address is not be empty';
                                }
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                              context: context,
                              hintText: 'Enter Your Password',
                              prefix: Icons.lock_outline,
                              isPassword: LoginCubit.get(context).isPassword,
                              //
                              suffix: LoginCubit.get(context).suffix,
                              //
                              controller: passController,
                              keybord: TextInputType.visiblePassword,
                              onSubmit: (valuee) {
                                if (formKey.currentState!.validate()) {
                                  /*  LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passController.text,
                                  );

                                 */
                                }
                              },
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is to short';
                                }
                              },
                              lable: 'Password',
                              suffixPressed: () {

                                LoginCubit.get(context)
                                    .ChangePasswordVisibility();


                              }),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Navigatorto(context: context, Widget: Reset_Password());
                                },
                                child: Container(
                                  child: Text(
                                    'forgot password?',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            //LoginCubit.get(context).login! ,
                            builder: (context) => defaultButton(
                              colors: Colors.red,
                              text: Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.white, fontSize: 30),
                              ),
                              function: () {
                                if (formKey.currentState!.validate()) {

                                  LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passController.text,
                                  );


                                }
                              },
                            ),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t Have Account?',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              defaultTextButton(
                                onPressed: () {

                                  Navigatorto(
                                      context: context, Widget: RegisterScreen());


                                },
                                lable: Text(
                                  'Register Here',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is LoginSuccessState){
            CachHelper.saveData(
              key: 'uId',
              value: state.uid,
            ).then((value) {
              uId = state.uid!;
              NavigatorAndFinish(context: context, Widget: SocialLayout());

              ShowTost(msg: 'Login Success', state: TostState.SUCCESS);

            }).catchError((Error) {

              ShowTost(msg: Error.toString(), state: TostState.ERROR);
            });

          }
        },
      ),
    );
  }
}
