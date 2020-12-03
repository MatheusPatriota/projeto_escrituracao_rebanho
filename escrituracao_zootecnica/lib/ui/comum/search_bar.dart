import 'package:flutter/material.dart';
import 'package:escrituracao_zootecnica/animal/class/animal.dart';
import 'package:escrituracao_zootecnica/animal/db/animal_database.dart';
import 'package:escrituracao_zootecnica/icones_personalizados/my_flutter_app_icons.dart';
import 'package:escrituracao_zootecnica/ui/animal/show_animal_information.dart';

enum OrderOptions { maleOption, femaleOption }

class DataSearch extends SearchDelegate<Animal> {
  AnimalHelper animalHelper = AnimalHelper();
  List<Animal> animais;
  bool maleOptionSelected = false;
  bool femaleOptionSelected = false;
  DataSearch(ani) {
    this.animais = ani;
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.maleOption:
        femaleOptionSelected = false;
        maleOptionSelected = true;
        break;

      case OrderOptions.femaleOption:
        maleOptionSelected = false;
        femaleOptionSelected = true;
        break;
      default:
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
      PopupMenuButton<OrderOptions>(
        icon: Icon(Icons.list),
        itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
          const PopupMenuItem<OrderOptions>(
            child: Text("Ordenar por Machos"),
            value: OrderOptions.maleOption,
          ),
          const PopupMenuItem<OrderOptions>(
            child: Text("Ordenar por Fêmeas"),
            value: OrderOptions.femaleOption,
          ),
        ],
        onSelected: _orderList,
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return MaterialApp();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print(animais);

    List<Animal> sugestionList = List();

    if (query.isEmpty) {
      // codigo inutil, possivel remocao
      sugestionList = animais;
    } else {
      for (var ani in animais) {
        if (maleOptionSelected == true) {
          if (ani.sexo == "Macho") {
            String aniFormatado = nomeAnimalExibido(ani).toLowerCase();
            if (aniFormatado.contains(query.toLowerCase())) {
              sugestionList.add(ani);
            }
          }
        } else if (femaleOptionSelected == true) {
          if (ani.sexo == "Fêmea") {
            String aniFormatado = nomeAnimalExibido(ani).toLowerCase();
            if (aniFormatado.contains(query.toLowerCase())) {
              sugestionList.add(ani);
            }
          }
        } else {
          String aniFormatado = nomeAnimalExibido(ani).toLowerCase();
          if (aniFormatado.contains(query.toLowerCase())) {
            sugestionList.add(ani);
          }
        }
      }
    }

    return ListView(
      children: listaDeTiles(sugestionList, context),
    );
  }

  List<Widget> listaDeTiles(sugest, context) {
    List<Widget> lista = List();
    for (var ani in sugest) {
      lista.add(
        ListTile(
          leading: Icon(MyFlutterApp.bode_icon),
          title: Text(
            nomeAnimalExibido(ani),
          ),
          onTap: () {
            Navigator.pop(context);
            _showCaprinoInformation(context: context, animal: ani);
          },
        ),
      );
    }
    return lista;
  }

  void _showCaprinoInformation({context, Animal animal}) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnimalInformation(
                  animal: animal,
                )));
  }

  String nomeAnimalExibido(Animal animal) {
    String resp = animal.idAnimal.toString();
    if (animal.brincoControle != null) {
      resp += " - " + animal.brincoControle;
    }
    if (animal.nome != null) {
      resp += " - " + animal.nome;
    }
    return resp;
  }
}
