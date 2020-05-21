import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ouvinos_caprinos/especie/db/especie_database.dart';
import 'package:ouvinos_caprinos/ui/home_page.dart';

class BemVindo extends StatefulWidget {
  BemVindo({Key key}) : super(key: key);

  @override
  _BemVindoState createState() => _BemVindoState();
}

class _BemVindoState extends State<BemVindo> {
  EspecieHelper especieHelper = EspecieHelper();

  @override
  void initState() {
    especieHelper.getAllEspecies();
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 4)).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            child: Image.asset("images/home_logo.png"),
          ),
        ));
  }
}
