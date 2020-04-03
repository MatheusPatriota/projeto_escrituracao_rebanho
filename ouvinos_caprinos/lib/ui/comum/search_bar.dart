import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/ui/caprino/show_caprino_information.dart';

class DataSearch extends SearchDelegate<Animal> {
  AnimalHelper animalHelper = AnimalHelper();
  List<Animal> animais;
  DataSearch(ani) {
    this.animais = ani;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
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
      sugestionList = List();
    } else {
      for (var ani in animais) {
        String aniFormatado = nomeAnimalExibido(ani).toLowerCase();
        if (aniFormatado.contains(query.toLowerCase())) {
          sugestionList.add(ani);
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
          leading: Icon(Icons.location_city),
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
            builder: (context) => CaprinoInformation(
                  caprino: animal,
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
