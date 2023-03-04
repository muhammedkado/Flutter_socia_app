import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme = ThemeData(
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 20.0,
      fontFamily: 'Jannah.ttf',
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Jannah.ttf',
      fontSize: 20.0,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Jannah.ttf',
      fontSize: 18.0,
      color: Colors.white,
      overflow: TextOverflow.ellipsis,
    ),
    bodyMedium: TextStyle(
        fontFamily: 'Jannah.ttf',
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.3,),
    bodySmall: TextStyle(
      fontFamily: 'Jannah.ttf',
      fontSize: 14.0,
      color: Colors.black,
      // overflow: TextOverflow.ellipsis,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Jannah.ttf',
      fontSize: 10.0,
      color: Colors.grey,
      overflow: TextOverflow.ellipsis,
    ),
  ),
  colorScheme: const ColorScheme(
    tertiary: Colors.grey,
    brightness: Brightness.light,
    primary: Colors.green,
    onPrimary: Colors.green,
    secondary: Colors.green,
    onSecondary: Colors.black,
    error: Colors.white,
    onError: Colors.white,
    background: Colors.grey,
    onBackground: Colors.black,
    surface: Colors.grey,
    outline: Colors.green,
    onSurface: Colors.green,
  ),

  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.green,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.green,
    ),
    titleTextStyle: TextStyle(
      color: Colors.green,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    color: Colors.white,
    elevation: 0.5,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.green,
    unselectedItemColor: Colors.grey,
    elevation: 0.0,
    backgroundColor: Colors.white,
  ),
);
ThemeData darkTheme = ThemeData(
  iconTheme: const IconThemeData(color: Colors.white),
  colorScheme: ColorScheme(
    outline: Colors.white,
    brightness: Brightness.dark,
    primary: Colors.white10,
    onPrimary: Colors.green,
    tertiary: Colors.white10,
    secondary: Colors.white10,
    onSecondary: Colors.grey,
    error: Colors.white,
    onError: HexColor('333739'),
    background: Colors.white,
    onBackground: Colors.white,
    surface: Colors.white10,
    onSurface: Colors.grey,
  ),
  scaffoldBackgroundColor: HexColor('333739'),
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      fontSize: 18.0,
      fontFamily: 'Jannah.ttf',
      color: Colors.white,

    ),
    bodyLarge: TextStyle(
      fontFamily: 'Jannah.ttf',
      fontSize: 20.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
        fontFamily: 'Jannah.ttf',
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.3),
    bodySmall: TextStyle(
      fontFamily: 'Jannah.ttf',
      fontSize: 14.0,
      color: Colors.white,
      // overflow: TextOverflow.ellipsis,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Jannah.ttf',
      fontSize: 14.0,
      color: Colors.grey,
      // overflow: TextOverflow.ellipsis,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Jannah.ttf',
      fontSize: 10.0,
      color: Colors.grey,
      overflow: TextOverflow.ellipsis,
    ),
  ),
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: const TextStyle(
        color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor('333739'),
        statusBarIconBrightness: Brightness.light),
    color: HexColor('333739'),
    elevation: 0.5,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    elevation: 20,
    backgroundColor: HexColor('333739'),
  ),
);
