import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/helper/animais_helper.dart';

// import 'package:url_launcher/url_launcher.dart';

import 'cadastro_ovino_page.dart';

import 'caprino_page.dart';

class OvinoPage extends StatefulWidget {
  @override
  _OvinoPageState createState() => _OvinoPageState();
}

class _OvinoPageState extends State<OvinoPage> {
  AnimalHelper helper = AnimalHelper();

  List<Animal> animaisOvinos = List();

  @override
  void initState() {
    super.initState();

    _getAllAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rebanho Ovino"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
             
            },
          ),
          IconButton(icon: Icon(Icons.sort), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCadastroOvinoPage,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:  <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Espécies Disponiveis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text('Caprinos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CaprinoPage(),
                      ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Ovinos'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
       body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: animaisOvinos.length,
          itemBuilder: (context, index) {
            return _animalCard(context, index);
          }
      ),
    );
  }


  
  Widget _animalCard(BuildContext context, int index){
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
                        image: animaisOvinos[index].img != null ?
                          FileImage(File(animaisOvinos[index].img)) :
                            AssetImage("images/ovino.png"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(animaisOvinos[index].nome ?? "",
                        style: TextStyle(fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(animaisOvinos[index].sexo ?? "",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(animaisOvinos[index].raca ?? "",
                        style: TextStyle(fontSize: 18.0),
                      )
                    ],
                  ),
                )
              ],
            ),
        ),
      ),
      onTap: (){
        _showOptions(context, index);
      },
    );
  }


  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                          _showCadastroOvinoPage(animal: animaisOvinos[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          helper.deleteAnimal(animaisOvinos[index].id);
                          setState(() {
                            animaisOvinos.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }


   void _showCadastroOvinoPage({Animal animal}) async {
    final recAnimal = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => CadastroOvinoPage(animalOvino: animal,))
    );
    if(recAnimal != null){
      if(animal != null){
        await helper.updateAnimal(recAnimal);
      } else {
        await helper.saveAnimal(recAnimal);
      }
      _getAllAnimals();
    }
  }

  void _getAllAnimals() {
    helper.getAllAnimals().then((list) {
      List<Animal> listaFinal = new List();
      
      for (var ani in list) {
        if(ani.tipo == "ovino"){
          listaFinal.add(ani);
        }
      }
      setState(() {
        animaisOvinos = listaFinal;
      });
    });
  }
}
