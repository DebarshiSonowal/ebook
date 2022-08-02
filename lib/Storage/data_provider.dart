

import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  int currentIndex = 0;
  int currentTab=0;
  setCurrentTab(int i) {
    currentTab = i;
    notifyListeners();
  }

  setIndex(int i) {
    currentIndex = i;
    notifyListeners();
  }
}


