import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/helper/animais_helper.dart';
import 'package:ouvinos_caprinos/ui/ovino_page.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'cadastro_caprino_page.dart';



class CaprinoPage extends StatefulWidget {
  @override
  _CaprinoPageState createState() => _CaprinoPageState();
}

class _CaprinoPageState extends State<CaprinoPage> {
  AnimalHelper helper = AnimalHelper();

  List<Animal> animais = List();

  @override
  void initState() {
    super.initState();

    _getAllAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rebanho Caprino"),
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
        onPressed: _showCadastroCaprinoPage,
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
               
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Ovinos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OvinoPage(),
                      ),
                );
              },
              
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
          itemCount: animais.length,
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
                        image: animais[index].img != null ?
                          FileImage(File(animais[index].img)) :
                            AssetImage("images/caprino.png"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(animais[index].nome ?? "",
                        style: TextStyle(fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(animais[index].sexo ?? "",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(animais[index].raca ?? "",
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
                          _showCadastroCaprinoPage(animal: animais[index]);
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
                          helper.deleteAnimal(animais[index].id);
                          setState(() {
                            animais.removeAt(index);
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


   void _showCadastroCaprinoPage({Animal animal}) async {
    final recAnimal = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => CadastroCaprinoPage(animal: animal,))
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
      setState(() {
        animais = list;
      });
    });
  }
}
