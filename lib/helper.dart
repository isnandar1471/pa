import 'package:flutter/material.dart';

void showAlert(context, String alert) {
  showDialog(
    context: context,
    builder: (context) {
      print(alert);
      return AlertDialog(
        title: Text("Alert"),
        content: Text(alert),
      );
    },
  );
}
