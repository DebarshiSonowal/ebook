import 'package:flutter/material.dart';

import '../Model/home_section.dart';

class CommonProvider extends ChangeNotifier {
  List<HomeSection> eBookSection = [];
  List<HomeSection> magazineSection = [];
  List<HomeSection> eNotesSection = [];

  // Loading states for each section
  bool isEbookSectionLoading = true;
  bool isMagazineSectionLoading = true;
  bool isEnotesSectionLoading = true;

  void setEbookHomeSections(List<HomeSection> section) {
    eBookSection = [];
    eBookSection = section;
    isEbookSectionLoading = false;
    notifyListeners();
  }

  void setMagazineHomeSections(List<HomeSection> section) {
    magazineSection = [];
    magazineSection = section;
    isMagazineSectionLoading = false;
    notifyListeners();
  }

  void setEnotesHomeSections(List<HomeSection> section) {
    eNotesSection = [];
    eNotesSection = section;
    isEnotesSectionLoading = false;
    notifyListeners();
  }

  // Method to reset loading states (useful for refresh)
  void resetLoadingStates() {
    isEbookSectionLoading = true;
    isMagazineSectionLoading = true;
    isEnotesSectionLoading = true;
    notifyListeners();
  }
}
