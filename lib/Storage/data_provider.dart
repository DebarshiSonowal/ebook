import 'package:ebook/Model/bookmark.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Model/home_section.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/book_category.dart';
import '../Model/book_format.dart';
import '../Model/cart_item.dart';
import '../Model/discount.dart';

class DataProvider extends ChangeNotifier {
  List<BookFormat>? formats = [];
  List<List<BookCategory>>? categoryList = [];
  List<List<HomeBanner>>? bannerList = [];
  List<List<HomeSection>>? homeSection = [];
  List<HomeBanner> cartBooks = [];
  List<BookmarkItem> bookmarks = [];
  List<CartItem> items = [];
  List<Discount> cupons = [];
  Cart? cartData;
  int currentIndex = 0;
  int currentCategory = 0;
  int currentTab = 0;
  int libraryTab = 0;

  setCurrentTab(int i) {
    currentTab = i;
    notifyListeners();
  }

  setCartData(Cart data) {
    cartData = data;
    notifyListeners();
  }

  setLibraryTab(int i) {
    libraryTab = i;
    notifyListeners();
  }

  setToCart(List<CartItem> list) {
    items = list;
    notifyListeners();
  }

  setCupons(List<Discount> list) {
    cupons = list;
    notifyListeners();
  }

  addToCart(HomeBanner book) {
    cartBooks.add(book);
    notifyListeners();
    Fluttertoast.showToast(msg: "Added to Cart");
  }

  setToBookmarks(List<BookmarkItem> books) {
    bookmarks = books;
    notifyListeners();
    Fluttertoast.showToast(msg: "Bookmarked");
  }

  addCategoryList(List<BookCategory> list) {
    categoryList?.add(list);
    notifyListeners();
  }

  addBannerList(List<HomeBanner> list) {
    bannerList?.add(list);
    notifyListeners();
  }

  addHomeSection(List<HomeSection> list) {
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
    currentCategory = i;
    notifyListeners();
  }
}
