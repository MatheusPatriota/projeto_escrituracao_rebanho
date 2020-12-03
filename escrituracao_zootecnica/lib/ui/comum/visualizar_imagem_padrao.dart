import 'dart:io';

import 'package:flutter/material.dart';

class ImagemPage extends StatelessWidget {
  final String imgUrl;

  ImagemPage(this.imgUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Imagem Ampliada"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.file(
          File(imgUrl),
        ),
      ),
    );
  }
}
