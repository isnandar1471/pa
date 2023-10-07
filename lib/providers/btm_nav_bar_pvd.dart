import 'package:flutter/material.dart';

class BtmNavBarIdxPvd with ChangeNotifier {
  int _val = 0;

  int get val => _val;

  void set val(int val) {
    this._val = val;
    notifyListeners();
  }
}
