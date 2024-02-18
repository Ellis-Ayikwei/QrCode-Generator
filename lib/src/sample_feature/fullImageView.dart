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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.menu),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
