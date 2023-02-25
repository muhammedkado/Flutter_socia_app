abstract class LoginStates{}
class LoginInitialState extends LoginStates{}
class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates{
  final String? uid;

  LoginSuccessState(this.uid);
}
class LoginErrorState extends LoginStates{}
class LoginChangePasswordVisibilityState extends LoginStates{}