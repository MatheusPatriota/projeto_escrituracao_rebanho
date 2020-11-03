import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ovinos_caprinos/ui/comum/bem_vindo.dart';

void main() {
  runApp(
    MaterialApp(
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
    ),
  );
}
