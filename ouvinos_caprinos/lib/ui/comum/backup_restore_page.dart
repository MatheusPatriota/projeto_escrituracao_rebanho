import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

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
                  // final dataDir = Directory(path);
                  // try {
                  //   final zipFile = File("backup_app_extensao");
                  //   ZipFile.createFromDirectory(
                  //       sourceDir: dataDir,
                  //       zipFile: zipFile,
                  //       recurseSubDirs: true);
                  // } catch (e) {
                  //   print(e);
                  // }
                  print(path); // which is data/data/<package_name>/databases
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
