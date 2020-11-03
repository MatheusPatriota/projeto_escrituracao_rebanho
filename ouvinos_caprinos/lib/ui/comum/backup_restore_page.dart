import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_archive/flutter_archive.dart' as fa;
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:share/share.dart';

class BackupRestorePage extends StatefulWidget {
  BackupRestorePage({Key key}) : super(key: key);

  @override
  _BackupRestorePageState createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backup/Restore"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.backup),
                title: Text('Realizar Backup'),
                onTap: () async {
                  String path = await getDatabasesPath();
                  final dataDir = Directory(path);
                  print(dataDir.existsSync());
                  var files = dataDir.listSync().toList();
                  var timestamp = DateTime.now().millisecondsSinceEpoch;
                  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
                  var encoder = ZipFileEncoder();
                  encoder.create(
                      dataDir.path + "/" + date.toIso8601String() + '.zip');
                  for (var element in files) {
                    if (element.path.substring(
                            element.path.length - 3, element.path.length) !=
                        "zip") {
                      encoder.addFile(element);
                    }
                  }
                  encoder.close();
                  files = dataDir.listSync().toList();
                  files.forEach((element) => print(element));
                  Share.shareFiles(['$path/' + date.toIso8601String() + '.zip'],
                      text: 'Backup File' + date.toIso8601String());
                  // which is data/data/<package_name>/databases
                }),
            ListTile(
                leading: Icon(Icons.restore),
                title: Text('Realizar Restore'),
                onTap: () async {
                  String path = await getDatabasesPath();
                  final dataDir = Directory(path);
                  print(dataDir.existsSync());
                  var files = dataDir.listSync().toList();

                  FlutterDocumentPickerParams params =
                      FlutterDocumentPickerParams(
                    allowedFileExtensions: ['zip'],
                    allowedMimeTypes: ['application/*'],
                    invalidFileNameSymbols: ['/'],
                  );
                  final pathDocument =
                      await FlutterDocumentPicker.openDocument(params: params);
                  print(pathDocument);
                  if (pathDocument != null) {
                    final zipFile = File(pathDocument);
                    try {
                      for (var element in files) {
                        if (element.path.substring(
                                element.path.length - 3, element.path.length) !=
                            // ignore: unnecessary_statements
                            "zip") (element.deleteSync());
                        print(element.path + ": deleted!");
                      }
                      fa.ZipFile.extractToDirectory(
                          zipFile: zipFile, destinationDir: dataDir);
                    } catch (e) {}
                  }

                  //reiniciar app
                  // Navigator.pop(context);
                  Future.delayed(Duration(seconds: 3), () {
                    //  SystemNavigator.pop();
                    alert();
                  });
                  // which is data/data/<package_name>/databases
                }),
          ],
        ),
      ),
    );
  }

  Widget alert(){
     Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
       exit(0);
     },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Importação bem sucedida!"),
    content: Text("O APP será fechado, por farvor inicie novamente"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  }
}
