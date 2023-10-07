import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> showAlert(ctx, String msg) async {
  await showDialog(
    context: ctx,
    builder: (ctx) {
      print(msg);
      return AlertDialog(
        title: Text("Alert"),
        content: Text(msg),
      );
    },
  );
}

/// Get `BASE_API_URL` from `.env` file
Future<String> get baseApiUrl async {
  await dotenv.load(fileName: '.env');

  String envKey = 'BASE_API_URL';
  return dotenv.get(envKey);
}
