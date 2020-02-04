import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/ui/caprino/caprino_page.dart';
import 'package:ouvinos_caprinos/ui/ovino/ovino_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> racas = ["caprino","ovino"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rebanhos Disponiveis"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: racas.length,
          itemBuilder: (context, index) {
            return _racasDisponiveis(context, index);
          }
      ),
    );
  }

   Widget _racasDisponiveis (BuildContext context, int index){
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
                        image: AssetImage("images/" + racas[index] + ".png"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        capitalize( racas[index]+"s"),
                        style: TextStyle(fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
        ),
      ),
      onTap: (){
        _goToPage(index);
      },
    );
  }


  void _goToPage(int index){
    if(index == 0){
      Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CaprinoPage(),
                    ),
              );
    }
    else{
       Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OvinoPage(),
                      ),
                );
    }
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