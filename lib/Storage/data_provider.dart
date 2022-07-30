

import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  int currentIndex=0;


  setIndex(int i){
    currentIndex = i;
    notifyListeners();
  }

}