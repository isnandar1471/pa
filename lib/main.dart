import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart' as img_pick;
import 'package:http/http.dart' as http;
import 'package:pa/result_page.dart';

final Dio dio = Dio();
void main() {
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
    if (image == null) return print('Image is empty');

    var uri = Uri(
      scheme: 'http',
      // host: '13.212.128.108',
      host: '192.168.1.6',
      port: 8000,
      path: 'semaphores/predict',
    );

    var request = http.MultipartRequest('POST', uri);
    Uint8List data = image!.readAsBytesSync();
    List<int> list = data.cast();
    request.files.add(
        http.MultipartFile.fromBytes('file', list, filename: 'myFile.png'));

    var response = await request.send();

    print(response);
    response.stream.bytesToString().asStream().listen((event) {
      var parsedJson = json.decode(event);
      print(parsedJson);
      print(response.statusCode);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            image: image!,
            result: parsedJson['predicted_value'],
          ),
        ),
      );
    });
    // final formdata = FormData.fromMap({
    //   // 'file': await MultipartFile.fromBytes(image!.readAsBytesSync()),
    //   'file': null,
    // });

    // dio.postUri(uri, data: formdata).then((result) {
    //   print(result.runtimeType);
    //   print('Success send request : $result');
    //   print('Success send request : ${result.statusCode}');
    //   // print('Success send request : ${result.body}');
    //   // Navigator.push(context, ResultPage(image: image, result: result))
    // }).catchError((error) {
    //   print('Error send request : $error');
    // });
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
