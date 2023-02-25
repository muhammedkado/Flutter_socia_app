abstract class RegisterState {}
class RegisterInitialState extends RegisterState{}
class RegisterChangePasswordVisibilityState extends RegisterState{}
class RegisterGenderSuccessState extends RegisterState{}
class RegisterCountrySuccessState extends RegisterState{}
class RegisterCheckBoxState extends RegisterState{}

class CreateLoadingState extends RegisterState{}
class CreateSuccessState extends RegisterState{}
class CreateErrorState extends RegisterState{}
class SaveInfoSuccessState extends RegisterState{}
class SaveInfoErrorState extends RegisterState{}