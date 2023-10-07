import 'package:flutter/material.dart';

class ImageFilePathPvd with ChangeNotifier {
  List<String> _paths = [];

  List<String> get paths => this._paths;

  void set paths(List<String> path) {
    this._paths = path;
    if (path.length > 0) {
      this._idxToShow = path.length - 1;
    } else {
      this._idxToShow = null;
    }
    notifyListeners();
  }

  int? _idxToShow;

  int? get idxToShow {
    return this._idxToShow;
  }

  void set idxToShow(int? idxToShow) {
    this._idxToShow = idxToShow;
    notifyListeners();
  }
}
