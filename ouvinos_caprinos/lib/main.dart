import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    //tema escuro em desenvolvimento
    // theme: ThemeData(
    //   brightness: Brightness.light,
    //   primaryColor: Colors.red,
    // ),
    // darkTheme: ThemeData(
    //   brightness: Brightness.dark,
    // ),
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

