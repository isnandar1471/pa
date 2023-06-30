import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart' as img_pick;
import 'package:http/http.dart' as http;

import '/helper.dart';
import '/result_page.dart';

final Dio dio = Dio();

void main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Semaphore Image Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Semaphore Image Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;

  Future pickImage() async {
    try {
      img_pick.XFile? image = await img_pick.ImagePicker()
          .pickImage(source: img_pick.ImageSource.camera);
      if (image == null) return;

      File imageTemporary = File(image.path);
      this.image = imageTemporary;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    setState(() {});
  }

  sendImage() async {
    if (image == null) {
      String alert = 'Image is empty';
      showAlert(context, alert);

      return;
    }

    var uri = Uri.parse("${dotenv.get('BASE_API_URL')}/semaphores/predict");

    var request = http.MultipartRequest('POST', uri);
    Uint8List data = image!.readAsBytesSync();
    List<int> list = data.cast();
    request.files.add(
        http.MultipartFile.fromBytes('file', list, filename: 'myFile.png'));

    http.StreamedResponse response;
    try {
      response = await request.send();
    } catch (e) {
      showAlert(context, e.toString());
      return;
    }

    if (response.statusCode != 200) {
      String alert = await response.stream.bytesToString();
      showAlert(context, alert);
      return;
    }

    response.stream.bytesToString().asStream().listen((event) {
      var parsedJson = json.decode(event);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            image: image!,
            result: event,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image != null
                ? Image.file(
                    image!,
                    width: 200,
                    // height: 200,
                    fit: BoxFit.fill,
                  )
                : FlutterLogo(
                    size: 200,
                  ),
            ElevatedButton(
              onPressed: () {
                print('Button Open Camera clicked');
                pickImage();
              },
              child: Text('Open Camera'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Button Send Image clicked');
                sendImage();
              },
              child: Text('Send Image'),
            ),
          ],
        ),
      ),
    );
  }
}
