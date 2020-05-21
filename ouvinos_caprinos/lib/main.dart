import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/ui/comum/bem_vindo.dart';

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
    home: BemVindo(),
    debugShowCheckedModeBanner: false,
  ));
}

