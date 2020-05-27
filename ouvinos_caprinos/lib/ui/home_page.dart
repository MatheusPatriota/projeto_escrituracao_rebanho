import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ouvinos_caprinos/especie/class/especie.dart';
import 'package:ouvinos_caprinos/especie/db/especie_database.dart';
import 'package:ouvinos_caprinos/ui/caprino/animal_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EspecieHelper _especieHelper = EspecieHelper();

  List<Especie> especies = List();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Rebanhos Disponiveis"),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: FutureBuilder<List>(
            future: _especieHelper.getAllEspecies(),
            builder: (BuildContext c, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return _especieDisponiveis(context, index, snapshot.data);
                    });
              } else if (snapshot.hasError) {
                return Text('Houve um erro ao listar as espécies');
              } else {
                return Text('Carregando dados...');
              }
            }));
  }

  Widget _especieDisponiveis(BuildContext context, int index, data) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("images/" +
                          data[index].descricao.toLowerCase() +
                          ".png"),
                      fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      capitalize(data[index].descricao + "s"),
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _goToPage(index);
      },
    );
  }

  void _goToPage(int index) {
    
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnimalPage(especieId: index+1,),
        ),
      );
    
  }

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }
}
