import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

@override
Widget defaultFormField({
  required BuildContext context,
  required TextEditingController controller ,
  required TextInputType keybord,
  required Function validate,
  required IconData prefix,
  String lable = 'Email Address',
  String hintText = 'Email Address',
  IconData? suffix,
  Function? onSubmit,
  Function? ontap,
  Function? suffixPressed,
  bool isPassword = false,
  bool isClickable = true,
}) =>
    TextFormField(

      style:  TextStyle(
        color:Colors.black,
      ),
      enabled: isClickable,
      onTap: () {
        if(ontap != null){
          ontap();
        }

      },
      obscureText: isPassword,
      controller: controller,
      keyboardType: keybord,
      validator: (value) {
        return validate(value);
      },
      autofocus: true,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color:Colors.black)
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        hintText: hintText,
        filled: false,
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: () {
            suffixPressed!();
          },
          icon: Icon(
            suffix,color: Colors.black,
          ),
        )
            : null,
        labelText: lable,
        labelStyle: TextStyle(color:Colors.black ),
        prefixIcon: Icon(
            prefix,
            color:Theme.of(context).colorScheme.onSurface
        ),

        //prefixIconColor:,

        border:const OutlineInputBorder(),

      ),
    );

@override
Widget defaultButton({
  double width = double.infinity,
  double? height,
  required Color colors,
  required Text text,
  required Function function,
}) =>
    Container(
      height: height,
      width: width,
      color: colors,
      child: MaterialButton(
        // color: defaultColor,
          onPressed: () {
            function();
          },
          child: text),
    );
Widget defaultTextButton({
  required Function onPressed,
  required Text lable,
}) =>
    TextButton(

      onPressed: () {
        onPressed();
      },
      child: lable,
    );


void ShowTost({required String msg, required TostState state}) =>
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: ChooseTostColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum TostState { WARNING, SUCCESS, ERROR }

Color? ChooseTostColor(TostState state) {
  Color color;
  switch (state) {
    case TostState.ERROR:
      {
        color = Colors.red;
      }
      break;
    case TostState.WARNING:
      {
        color = Colors.amber;
      }
      break;
    case TostState.SUCCESS:
      {
        color = Colors.green;
      }
      break;
  }
  return color;
}

NavigatorAndFinish({required context, required Widget}) =>
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Widget), (route) => false);

Navigatorto({required context, required Widget}) => Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => Widget),
);
