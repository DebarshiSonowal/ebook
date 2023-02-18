import 'package:ebook/Model/bookmark.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Model/home_section.dart';
import 'package:ebook/Model/order_history.dart';
import 'package:ebook/Model/writer.dart';
import 'package:ebook/UI/Routes/Drawer/history.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/book_category.dart';
import '../Model/book_details.dart';
import '../Model/book_format.dart';
import '../Model/cart_item.dart';
import '../Model/discount.dart';
import '../Model/profile.dart';

class DataProvider extends ChangeNotifier {
  List<BookFormat>? formats = [];
  List<List<BookCategory>> categoryList = [];
  List<List<Book>>? bannerList = [];
  List<List<HomeSection>>? homeSection = [];
  List<Book> cartBooks = [], myBooks = [], search_results = [];
  List<BookmarkItem> bookmarks = [];
  List<CartItem> items = [];
  List<Discount> cupons = [];
  List<OrderHistory> orders = [];
  Cart? cartData;
  Profile? profile;
  int currentIndex = 0;
  int currentCategory = 0;
  int currentTab = 0;
  int libraryTab = 0;
  String title = '';
  Book? details;
  writer? writerDetails;

  clearAllData(){
    // formats=[];
    // categoryList=[];
    // bannerList=[];
    // homeSection=[];
    cartBooks=[];
    myBooks=[];
    search_results=[];
    bookmarks=[];
    items=[];
    // cupons=[];
    orders=[];
    cartData=null;
    profile=null;
    notifyListeners();
  }

  setBookDetails(Book data) {
    print("Book details ${details?.title}");
    details = data;
    notifyListeners();
  }

  setTitle(String txt) {
    title = txt;
    notifyListeners();
  }

  setCurrentTab(int i) {
    print('current tab ${i}');
    currentTab = i;
    notifyListeners();
  }

  setProfile(Profile data) {
    profile = data;
    notifyListeners();
  }

  setProfileClear() {
    profile = null;
    notifyListeners();
  }

  setMyBooks(List<Book> list) {
    myBooks = list;
    notifyListeners();
  }

  setSearchResult(List<Book> list) {
    search_results = list;
    notifyListeners();
  }

  setHistory(List<OrderHistory> list) {
    orders = list;
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

  addToCart(Book book) {
    cartBooks.add(book);
    notifyListeners();
    Fluttertoast.showToast(msg: "Added to Cart");
  }

  setToBookmarks(List<BookmarkItem> books) {
    bookmarks = books;
    notifyListeners();
    // Fluttertoast.showToast(msg: "Bookmarked");
  }

  addCategoryList(List<BookCategory> list) {
    categoryList.add(list);
    notifyListeners();
  }

  addBannerList(List<Book> list) {
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

  setWriterDetails(writer? writer) {
    writerDetails = writer;
    notifyListeners();
  }
}
