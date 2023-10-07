import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart' as img_pick;
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/helper.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  File? image;

  Future pickImage() async {
    try {
      img_pick.XFile? image = await img_pick.ImagePicker().pickImage(source: img_pick.ImageSource.camera);
      if (image == null) return;

      File imageTemporary = File(image.path);
      this.image = imageTemporary;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  sendImage() async {
    if (image == null) {
      String alert = 'Image is empty';
      return;
    }

    var uri = Uri.parse("$baseApiUrl/semaphores/predict");

    var request = http.MultipartRequest('POST', uri);
    Uint8List data = image!.readAsBytesSync();
    List<int> list = data.cast();
    request.files.add(http.MultipartFile.fromBytes('file', list, filename: 'myFile.png'));

    http.StreamedResponse response;
    try {
      response = await request.send();
    } catch (e) {
      // showAlert(context, e.toString());
      return;
    }

    if (response.statusCode != 200) {
      String alert = await response.stream.bytesToString();
      // showAlert(context, alert);
      return;
    }

    response.stream.bytesToString().asStream().listen((event) {
      var parsedJson = jsonDecode(event);

      print(event);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ResultPage(
      //       image: image!,
      //       result: event,
      //     ),
      //   ),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
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
              child: Text(AppLocalizations.of(context)!.openCamera),
            ),
            ElevatedButton(
              onPressed: () {
                print('Button Send Image clicked');
                sendImage();
              },
              child: Text(AppLocalizations.of(context)!.sendImage),
            ),
          ],
        ),
      ),
    );
  }
}
