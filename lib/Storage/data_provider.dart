import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Model/home_section.dart';
import 'package:flutter/material.dart';

import '../Model/book_category.dart';
import '../Model/book_format.dart';

class DataProvider extends ChangeNotifier {
  List<BookFormat>? formats = [];
  List<List<BookCategory>>? categoryList=[];
  List<List<HomeBanner>>? bannerList=[];
  List<List<HomeSection>>? homeSection=[];
  int currentIndex = 0;
  int currentTab = 0;

  setCurrentTab(int i) {
    currentTab = i;
    notifyListeners();
  }

  addCategoryList(List<BookCategory> list){
    categoryList?.add(list);
    notifyListeners();
  }
  addBannerList(List<HomeBanner> list){
    bannerList?.add(list);
    notifyListeners();
  }
 addHomeSection(List<HomeSection> list){
    homeSection?.add(list);
    notifyListeners();
  }

  setFormats(List<BookFormat> list) {
    print(list);
    formats = list ?? [];
    notifyListeners();
  }

  setIndex(int i) {
    currentIndex = i;
    notifyListeners();
  }
}
