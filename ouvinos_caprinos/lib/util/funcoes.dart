import 'package:flutter/material.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';

String ehvazio(dynamic a) {
  String stringFinal = a;
  if (a == null) {
    stringFinal = "Não Informado";
  }
  return stringFinal;
}

String idadeAnimal(String ano, String mes) {
  DateTime _dataAtual = new DateTime.now();
  String anoAtual = "${_dataAtual.year}";
  String mesAtual = "${_dataAtual.month}";
  String resultado = "";
  int anos = int.parse(anoAtual) - int.parse(ano);
  int meses = int.parse(mesAtual) - int.parse(mes);

  if (anos >= 1) {
    resultado = anos.toString() + " ano(s) e " + meses.toString() + " meses";
  } else {
    resultado = meses.toString() + " meses";
  }

  return resultado;
}

// tipo 1 para texto, tipo 2 para valores de compra
InputDecoration estiloPadrao(String texto, int tipo) {
  if (tipo == 1) {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$texto',
    );
  } else {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$texto',
      prefixText: "R\$",
    );
  }
}

Container espacamentoPadrao(){
  return Container(
    padding: EdgeInsets.all(5.0),
  );
}


// Padding exibicaoPadraoDeEvento(){
//   return Padding(
//               padding: const EdgeInsets.only(
//                 left: 16.0,
//                 right: 16.0,
//               ),
//               child: Material(
//                 elevation: 2.0,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
//                 child: GroovinExpansionTile(
//                   defaultTrailingIconColor: Colors.indigoAccent,
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.indigoAccent,
//                     child: Icon(
//                       Icons.person,
//                       color: Colors.white,
//                     ),
//                   ),
//                   title: Text("Test Person", style: TextStyle(color: Colors.black),),
//                   subtitle: Text("123-456-7890"),
//                   onExpansionChanged: (value) {
//                     // setState(() {
//                     //   isExpanded = value;
//                     // });
//                   },
//                   inkwellRadius: !isExpanded
//                       ? BorderRadius.all(Radius.circular(8.0))
//                       : BorderRadius.only(
//                     topRight: Radius.circular(8.0),
//                     topLeft: Radius.circular(8.0),
//                   ),
//                   children: <Widget>[
//                     ClipRRect(
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(5.0),
//                         bottomRight: Radius.circular(5.0),
//                       ),
//                       child: Column(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 IconButton(
//                                   icon: Icon(Icons.delete),
//                                   onPressed: () {},
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.notifications),
//                                   onPressed: () {},
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.edit),
//                                   onPressed: () {},
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.comment),
//                                   onPressed: () {},
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.phone),
//                                   onPressed: () {},
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
// }