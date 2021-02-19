import 'package:flutter/material.dart';

class SearchService with ChangeNotifier {
  bool manualSelection = false;

  void changeManualSelection(bool value) {
    this.manualSelection = value;
    notifyListeners();
  }
}
