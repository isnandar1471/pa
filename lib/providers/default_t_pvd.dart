import 'package:flutter/material.dart';

class DefaultTPvd<T> with ChangeNotifier {
  T _value;

  DefaultTPvd(this._value);

  T get value => this._value;

  void set value(T value) {
    this._value = value;
    notifyListeners();
  }
}

class BtmNavBarIdxPvdV2 extends DefaultTPvd<int> {
  BtmNavBarIdxPvdV2() : super(0);
}

class ImageFilePathPvdV2 extends DefaultTPvd<List<String>> {
  ImageFilePathPvdV2() : super([]);
}

class ServerUrlPvd extends DefaultTPvd<String> {
  ServerUrlPvd() : super('');
}

class ActivityHasChangePvd extends DefaultTPvd<bool> {
  ActivityHasChangePvd() : super(false);
}
