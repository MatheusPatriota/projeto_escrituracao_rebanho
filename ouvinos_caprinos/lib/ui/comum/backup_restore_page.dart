import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_archive/flutter_archive.dart';
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
                  files.forEach((element) => encoder.addFile(element));
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
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
