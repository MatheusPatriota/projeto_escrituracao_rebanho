import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/categoria/db/categoria_database.dart';
import 'package:ouvinos_caprinos/especie/class/especie.dart';
import 'package:ouvinos_caprinos/especie/db/especie_database.dart';
import 'package:ouvinos_caprinos/icones_personalizados/my_flutter_app_icons.dart';
import 'package:ouvinos_caprinos/raca/db/raca_database.dart';
import 'package:ouvinos_caprinos/ui/animal/cadastro_animal_page.dart';
import 'package:ouvinos_caprinos/ui/animal/show_animal_information.dart';
import 'package:ouvinos_caprinos/ui/comum/exclusao_page.dart';
import 'package:ouvinos_caprinos/ui/comum/search_bar.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

enum OrderOptions { orderaz, orderza, orderbyid }

class AnimalPage extends StatefulWidget {
  final int especieId;

  AnimalPage({this.especieId});

  @override
  _AnimalPageState createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  // variaveis para inicializacao do db
  AnimalHelper animalHelper = AnimalHelper();
  CategoriaHelper categoriaHelper = CategoriaHelper();
  RacaHelper racaHelper = RacaHelper();
  EspecieHelper especieHelper = EspecieHelper();
  // variaveis para armazenar os estados dos animais

  List<Animal> animais = List();
  List<Animal> animaisVendidos = List();
  List<Animal> animaisMortos = List();
  List<Animal> animaisExcluidos = List();
  List<Animal> allAnimals = List();

  List<Especie> especies = List();

  @override
  void initState() {
    super.initState();
    _getAllCategorias();
    _getAllEspecies();
    _getAllRacas();
    _getAllAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //tema escuro em desenvolvimento
      // theme: ThemeData(
      //   brightness: Brightness.light,
      //   primaryColor: Colors.red,
      // ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      // ),

      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Rebanho " + especies[widget.especieId - 1].descricao ??
                "Rebanho"),
            backgroundColor: Colors.green,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                      context: context, delegate: DataSearch(allAnimals));
                },
              ),
              PopupMenuButton<OrderOptions>(
                icon: Icon(Icons.list),
                itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar de A-Z"),
                    value: OrderOptions.orderaz,
                  ),
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar de Z-A"),
                    value: OrderOptions.orderza,
                  ),
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar pelo Id"),
                    value: OrderOptions.orderbyid,
                  ),
                ],
                onSelected: _orderList,
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "Disponíveis"),
                Tab(text: "Vendidos"),
                Tab(text: "Mortos"),
                Tab(text: "Excluídos"),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showCadastroAnimalPage,
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: listaLateral(),
            ),
          ),
          body: TabBarView(
            children: [
              RefreshIndicator(
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: animais.length,
                  itemBuilder: (context, index) {
                    return _animalCard(context, index, animais);
                  },
                ),
                onRefresh: _reloadLists,
              ),
              RefreshIndicator(
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: animaisVendidos.length,
                  itemBuilder: (context, index) {
                    return _animalCard(context, index, animaisVendidos);
                  },
                ),
                onRefresh: _reloadLists,
              ),
              RefreshIndicator(
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: animaisMortos.length,
                  itemBuilder: (context, index) {
                    return _animalCard(context, index, animaisMortos);
                  },
                ),
                onRefresh: _reloadLists,
              ),
              RefreshIndicator(
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: animaisExcluidos.length,
                  itemBuilder: (context, index) {
                    return _animalCard(context, index, animaisExcluidos);
                  },
                ),
                onRefresh: _reloadLists,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _reloadLists() async {
    await Future.delayed(
      Duration(seconds: 2),
      () => animalHelper.getAllAnimals().then(
        (list) {
          print(list);
          List<Animal> listaFinalDisponiveis = new List();
          List<Animal> listaFinalVendidos = new List();
          List<Animal> listaFinalMortos = new List();
          List<Animal> listaFinalExcluidos = new List();

          for (var ani in list) {
            if (ani.idEspecie == widget.especieId) {
              if (ani.status == "0") {
                listaFinalDisponiveis.add(ani);
              } else if (ani.status == "1") {
                listaFinalVendidos.add(ani);
              } else if (ani.status == "2") {
                listaFinalMortos.add(ani);
              } else if (ani.status == "3") {
                listaFinalExcluidos.add(ani);
              }
            }
          }
          setState(() {
            animais = listaFinalDisponiveis;
            animaisVendidos = listaFinalVendidos;
            animaisMortos = listaFinalMortos;
            animaisExcluidos = listaFinalExcluidos;
            allAnimals = list;
          });
        },
      ),
    );
  }

  Widget _animalCard(BuildContext context, int index, List<Animal> lista) {
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
                      image: lista[index].img != null
                          ? FileImage(File(lista[index].img))
                          : AssetImage("images/" +
                              especies[widget.especieId - 1]
                                  .descricao
                                  .toLowerCase() +
                              ".png"),
                      fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Brinco: " + ehvazio(lista[index].brincoControle) ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "ID: " + lista[index].idAnimal.toString() ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Nome: " + ehvazio(lista[index].nome) ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Sexo: " + lista[index].sexo ?? "",
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index, lista);
        _getAllAnimals();
      },
    );
  }

  void _showOptions(BuildContext context, int index, List<Animal> lista) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {
              _getAllAnimals();
            },
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: listaOpcoes(index, lista, context)),
              );
            },
          );
        });
  }

  List<Widget> listaOpcoes(
      int index, List<Animal> lista, BuildContext context) {
    List<Widget> listaOpcoes = List();
    //ver informacoes comum para todos os status
    listaOpcoes.add(Padding(
      padding: EdgeInsets.all(10.0),
      child: FlatButton(
        child: Text(
          "Ver Informações",
          style: TextStyle(color: Colors.green, fontSize: 20.0),
        ),
        onPressed: () {
          Navigator.pop(context);
          _showCaprinoInformation(animal: lista[index]);
        },
      ),
    ));
    // caso o status do animal seja ativo
    if (lista[index].status == "0") {
      listaOpcoes.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: FlatButton(
          child: Text(
            "Editar",
            style: TextStyle(color: Colors.green, fontSize: 20.0),
          ),
          onPressed: () {
            Navigator.pop(context);
            _showCadastroAnimalPage(animal: lista[index]);
          },
        ),
      ));
      listaOpcoes.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: FlatButton(
          child: Text(
            "Excluir",
            style: TextStyle(color: Colors.red, fontSize: 20.0),
          ),
          onPressed: () async {
            Navigator.pop(context);
            final recExclusao = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExclusaoPage(
                  animalExcluido: lista[index],
                ),
              ),
            );
            if (recExclusao.motivoRemocao != null) {
              await animalHelper.updateAnimal(recExclusao);
            }
            _getAllAnimals();
          },
        ),
      ));
    }
    // caso o status do animal seja vendido-morto-excluido
    else {
      listaOpcoes.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: FlatButton(
          child: Text(
            "Restaurar Animal",
            style: TextStyle(color: Colors.green, fontSize: 20.0),
          ),
          onPressed: () {
            Navigator.pop(context);
            //atualizar status
            lista[index].status = "0";
            // caso o animal tenha sido vendido
            lista[index].nomeComprador = null;
            lista[index].valorVenda = null;
            lista[index].dataVendaAnimal = null;
            lista[index].anotacoesVenda = null;
            // caso o animal tenha sido morto
            lista[index].imgMorte = null;
            lista[index].dataMorte = null;
            lista[index].descricaoMorte = null;
            // caso o animal tenha sido removido
            lista[index].dataRemocao = null;
            lista[index].motivoRemocao = null;
            //atualizando o animal no bd

            animalHelper.updateAnimal(lista[index]);
          },
        ),
      ));
    }

    return listaOpcoes;
  }

  List<Widget> listaLateral() {
    List<Widget> listaLateral = List();

    listaLateral.add(
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
    );

    for (var especie in especies) {
      listaLateral.add(ListTile(
        leading: Icon((MyFlutterApp.ovelha_icon)),
        title: Text(especie.descricao),
        onTap: () {
          if (especie.id != widget.especieId) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnimalPage(
                  especieId: especie.id,
                ),
              ),
            );
          }
        },
      ));
    }

    listaLateral.add(
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Configurações'),
      ),
    );
    return listaLateral;
  }

  // direciona para a pagina de exibicao do animal
  void _showCaprinoInformation({Animal animal}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalInformation(
          animal: animal,
        ),
      ),
    );
    _getAllAnimals();
  }

  // direciona para a pagina de cadastro do caprino
  void _showCadastroAnimalPage({Animal animal}) async {
    final recAnimal = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroAnimalPage(
          animal: animal,
          idEspecie: widget.especieId,
        ),
      ),
    );
    if (recAnimal != null) {
      if (animal != null) {
        await animalHelper.updateAnimal(recAnimal);
      } else {
        await animalHelper.saveAnimal(recAnimal);
      }

      _getAllAnimals();
    }
  }

// carrega o banco de dados categoria
  void _getAllCategorias() {
    categoriaHelper.getAllCategorias();
  }

// carrega o banco de dados de racas
  void _getAllRacas() {
    racaHelper.getAllRacas();
  }

// carrega o banco de dados das especies
  void _getAllEspecies() {
    especieHelper.getAllEspecies().then((listaE) {
      setState(() {
        especies = listaE;
      });
    });
  }

  // recupera todos os animais cadastrados no banco de dados
  void _getAllAnimals() {
    animalHelper.getAllAnimals().then((list) {
      print(list);
      List<Animal> listaFinalDisponiveis = new List();
      List<Animal> listaFinalVendidos = new List();
      List<Animal> listaFinalMortos = new List();
      List<Animal> listaFinalExcluidos = new List();

      for (var ani in list) {
        if (ani.idEspecie == widget.especieId) {
          if (ani.status == "0") {
            listaFinalDisponiveis.add(ani);
          } else if (ani.status == "1") {
            listaFinalVendidos.add(ani);
          } else if (ani.status == "2") {
            listaFinalMortos.add(ani);
          } else if (ani.status == "3") {
            listaFinalExcluidos.add(ani);
          }
        }
      }
      setState(() {
        animais = listaFinalDisponiveis;
        animaisVendidos = listaFinalVendidos;
        animaisMortos = listaFinalMortos;
        animaisExcluidos = listaFinalExcluidos;
        allAnimals = list;
      });
    });
  }

  // ordena a lista de acordo com a preferencia
  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        animais.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        animaisVendidos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        animaisMortos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        animaisExcluidos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        animais.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        animaisVendidos.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        animaisMortos.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        animaisExcluidos.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderbyid:
        animais.sort((a, b) {
          return a.idAnimal.compareTo(b.idAnimal);
        });
        animaisVendidos.sort((a, b) {
          return a.idAnimal.compareTo(b.idAnimal);
        });
        animaisMortos.sort((a, b) {
          return a.idAnimal.compareTo(b.idAnimal);
        });
        animaisExcluidos.sort((a, b) {
          return a.idAnimal.compareTo(b.idAnimal);
        });
        break;
    }
    setState(() {});
  }
}
