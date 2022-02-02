import 'package:flutter/material.dart';
class Constant {

  static String url='https://my-photogallery-server.herokuapp.com/api';
  static const defaultBlack = 0xFF000000;
  static const MaterialColor black = MaterialColor(
    defaultBlack,
    <int, Color>{
      50: Color(defaultBlack),
      100: Color(defaultBlack),
      200: Color(defaultBlack),
      300: Color(defaultBlack),
      400: Color(defaultBlack),
      500: Color(defaultBlack),
      600: Color(defaultBlack),
      700: Color(defaultBlack),
      800: Color(defaultBlack),
      900: Color(defaultBlack),
    },
  );
}