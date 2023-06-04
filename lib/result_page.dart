import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final File image;

  final String result;

  const ResultPage({super.key, required this.image, required this.result});

  @override
  State<ResultPage> createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.file(
              widget.image,
              width: 200,
              // height: 200,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Prediksi : ${widget.result}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
