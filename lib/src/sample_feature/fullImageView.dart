import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrcodescanner/src/sample_feature/first_qr.dart';

class FullImageView extends StatelessWidget {
  final String imagePath;
  final int index;

  const FullImageView({Key? key, required this.imagePath, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        actions: [
          GestureDetector(
            onTap: () {
              showPopupMenu(context, index);
            },
            child: Icon(Icons.menu),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
