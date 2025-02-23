import 'package:flutter/material.dart';

import '../Model/home_section.dart';

class CommonProvider extends ChangeNotifier {
  List<HomeSection> eBookSection = [];
  List<HomeSection> magazineSection = [];
  List<HomeSection> eNotesSection = [];

  void setEbookHomeSections(List<HomeSection> section) {
    eBookSection = [];
    eBookSection = section;
    notifyListeners();
  }

  void setMagazineHomeSections(List<HomeSection> section) {
    magazineSection = [];
    magazineSection = section;
    notifyListeners();
  }

  void setEnotesHomeSections(List<HomeSection> section) {
    eNotesSection = [];
    eNotesSection = section;
    notifyListeners();
  }
}
