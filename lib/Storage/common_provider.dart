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

  // Error states
  bool hasEbookError = false;
  bool hasMagazineError = false;
  bool hasEnotesError = false;

  void setEbookHomeSections(List<HomeSection> section) {
    print(
        "🔥 PROVIDER: Setting ${section.length} e-book sections, stopping loading");
    eBookSection = [];
    eBookSection = section;
    isEbookSectionLoading = false;
    hasEbookError = false;
    notifyListeners();
  }

  void setMagazineHomeSections(List<HomeSection> section) {
    print(
        "🔥 PROVIDER: Setting ${section.length} magazine sections, stopping loading");
    magazineSection = [];
    magazineSection = section;
    isMagazineSectionLoading = false;
    hasMagazineError = false;
    notifyListeners();
  }

  void setEnotesHomeSections(List<HomeSection> section) {
    print(
        "🔥 PROVIDER: Setting ${section.length} e-notes sections, stopping loading");
    eNotesSection = [];
    eNotesSection = section;
    isEnotesSectionLoading = false;
    hasEnotesError = false;
    notifyListeners();
  }

  // Error handling methods
  void setEbookError() {
    print("🔥 PROVIDER: Setting e-book error, stopping loading");
    isEbookSectionLoading = false;
    hasEbookError = true;
    notifyListeners();
  }

  void setMagazineError() {
    print("🔥 PROVIDER: Setting magazine error, stopping loading");
    isMagazineSectionLoading = false;
    hasMagazineError = true;
    notifyListeners();
  }

  void setEnotesError() {
    print("🔥 PROVIDER: Setting e-notes error, stopping loading");
    isEnotesSectionLoading = false;
    hasEnotesError = true;
    notifyListeners();
  }

  // Force stop loading (useful for timeout scenarios)
  void forceStopEbookLoading() {
    print("🔥 PROVIDER: Force stopping e-book loading");
    isEbookSectionLoading = false;
    notifyListeners();
  }

  void forceStopMagazineLoading() {
    print("🔥 PROVIDER: Force stopping magazine loading");
    isMagazineSectionLoading = false;
    notifyListeners();
  }

  void forceStopEnotesLoading() {
    print("🔥 PROVIDER: Force stopping e-notes loading");
    isEnotesSectionLoading = false;
    notifyListeners();
  }

  // Method to reset loading states (useful for refresh)
  void resetLoadingStates() {
    print("🔥 PROVIDER: Resetting all loading states to true");
    isEbookSectionLoading = true;
    isMagazineSectionLoading = true;
    isEnotesSectionLoading = true;
    hasEbookError = false;
    hasMagazineError = false;
    hasEnotesError = false;
    notifyListeners();
  }
}
