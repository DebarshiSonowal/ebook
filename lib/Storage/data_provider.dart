import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Model/home_section.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/book_category.dart';
import '../Model/book_format.dart';

class DataProvider extends ChangeNotifier {
  List<BookFormat>? formats = [];
  List<List<BookCategory>>? categoryList=[];
  List<List<HomeBanner>>? bannerList=[];
  List<List<HomeSection>>? homeSection=[];
  List<HomeBanner> cartBooks=[];
  int currentIndex = 0;
  int currentCategory = 0;
  int currentTab = 0;

  setCurrentTab(int i) {
    currentTab = i;
    notifyListeners();
  }

  addToCart(HomeBanner book){
    cartBooks.add(book);
    notifyListeners();
    Fluttertoast.showToast(msg: "Added to Cart");
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
  setCategory(int i) {
    currentCategory  = i;
    notifyListeners();
  }
}
