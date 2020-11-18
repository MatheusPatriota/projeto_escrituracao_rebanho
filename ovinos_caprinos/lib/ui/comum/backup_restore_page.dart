import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_archive/flutter_archive.dart' as fa;
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

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
                  final String pathImages =
                      (await getApplicationSupportDirectory()).path;
                  final dataDirImages = Directory(pathImages);
                  var filesImages = dataDirImages.listSync().toList();
                  print(dataDirImages);
                  print(filesImages);
                  print(dataDir.existsSync());
                  var files = dataDir.listSync().toList();
                  var timestamp = DateTime.now().millisecondsSinceEpoch;
                  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
                  var encoder = ZipFileEncoder();
                  encoder.create(
                      dataDir.path + "/" + date.toUtc().toString() + '.zip');
                  for (var element in files) {
                    if (element.path.substring(
                            element.path.length - 3, element.path.length) !=
                        "zip") {
                      encoder.addFile(element);
                    }
                  }
                  for (var element in filesImages) {
                    if (element.path.substring(
                            element.path.length - 3, element.path.length) ==
                        "jpg") {
                      encoder.addFile(element);
                    }
                  }
                  encoder.close();

                  files.forEach((element) => print(element));
                  filesImages.forEach((element) => print(element));
                  Share.shareFiles(
                      ['$path/' + date.toUtc().toString() + '.zip'],
                      text: 'Backup File' + date.toUtc().toString());
                  // which is data/data/<package_name>/databases
                }),
            ListTile(
                leading: Icon(Icons.restore),
                title: Text('Realizar Restore'),
                onTap: () async {
                  String path = await getDatabasesPath();

                  final dataDir = Directory(path);
                  Directory imagensDir = new Directory(
                      "/data/user/0/matheuspatriota.com.br.ovinos_caprinos/files");
                  print(dataDir.existsSync());
                  var files = dataDir.listSync().toList();
                  var imagesFiles = imagensDir.listSync().toList();

                  FlutterDocumentPickerParams params =
                      FlutterDocumentPickerParams(
                    allowedFileExtensions: ['zip'],
                    allowedMimeTypes: ['application/*'],
                    invalidFileNameSymbols: ['/'],
                  );
                  final pathDocument =
                      await FlutterDocumentPicker.openDocument(params: params);
                  if (pathDocument != null) {
                    print(pathDocument);
                    if (pathDocument != null) {
                      final zipFile = File(pathDocument);
                      try {
                        bool val = true;
                        String dataValidar = zipFile.path.substring(
                            zipFile.path.length - 28, zipFile.path.length - 18);
                        print(dataValidar + "  arquivo");
                        try {
                          DateTime todayDate = DateTime.parse(dataValidar);
                          print(todayDate);
                        } catch (e) {
                          val = false;
                        }
                        if (val == true) {
                          for (var element in files) {
                            if (element.path.substring(element.path.length - 3,
                                    element.path.length) !=
                                // ignore: unnecessary_statements
                                "zip") (element.deleteSync());
                            print(element.path + ": deleted!");
                          }
                          for (var element in imagesFiles) {
                            if (element.path.substring(element.path.length - 3,
                                    element.path.length) ==
                                // ignore: unnecessary_statements
                                "jpg") (element.deleteSync());
                            print(element.path + ": deleted!");
                          }

                          //aleterar futuramente

                          fa.ZipFile.extractToDirectory(
                              zipFile: zipFile, destinationDir: imagensDir);
                          fa.ZipFile.extractToDirectory(
                              zipFile: zipFile, destinationDir: dataDir);
                          Future.delayed(Duration(seconds: 3), () {
                            //  SystemNavigator.pop();
                            alert(0);
                          });
                        } else {
                          alert(2);
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    }
                  } else {
                    alert(1);
                  }

                  //reiniciar app
                  // Navigator.pop(context);

                  // which is data/data/<package_name>/databases
                }),
          ],
        ),
      ),
    );
  }

  void alert(int cond) {
    AlertDialog alert;
    if (cond == 0) {
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          exit(0);
        },
      );

      // set up the AlertDialog
      alert = AlertDialog(
        title: Text("Importação bem sucedida!"),
        content: Text("O APP será fechado, por farvor inicie novamente"),
        actions: [
          okButton,
        ],
      );
    } else if (cond == 1) {
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      alert = AlertDialog(
        title: Text("Não foi possível realizar importação!"),
        content: Text("Operação não realizada"),
        actions: [
          okButton,
        ],
      );
    } else {
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      alert = AlertDialog(
        title: Text("Arquivo Invalido!"),
        content: Text("Operação não realizada"),
        actions: [
          okButton,
        ],
      );
    }

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
