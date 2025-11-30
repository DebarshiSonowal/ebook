import 'package:ebook/Model/bookmark.dart';
import 'package:ebook/Model/library.dart';
import 'package:ebook/Model/library_book_details.dart';
import 'package:ebook/Model/order_history.dart';
import 'package:ebook/Model/writer.dart';
import 'package:ebook/Model/advertisement.dart';
import 'package:ebook/UI/Routes/Drawer/history.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/book_category.dart';
import '../Model/book_details.dart';
import '../Model/book_format.dart';
import '../Model/cart_item.dart';
import '../Model/discount.dart';
import '../Model/enote_banner.dart';
import '../Model/enote_category.dart';
import '../Model/enote_section.dart';
import '../Model/enotes_chapter.dart';
import '../Model/enotes_details.dart';
import '../Model/home_banner.dart';
import '../Model/notification_model.dart';
import '../Model/profile.dart';
import '../Model/reward_response.dart';

class DataProvider extends ChangeNotifier {
  // Book data
  Book? details;
  final List<Book> cartBooks = [];
  List<Book> myBooks = [];
  List<Book> searchResults = [];
  List<Book> enotesList = [];
  List<BookFormat>? formats = [];
  List<List<Book>>? bannerList = [];

  // Categories
  final List<List<BookCategory>> categoryList = [];
  List<EnotesCategory> enotes = [];

  // Library
  List<LibraryBookDetailsModel> _library = [];
  List<LibraryBookDetailsModel> _specificLibraryBooks = [];
  List<Library> libraries = [], publicLibraries = [];
  List<BookmarkItem> bookmarks = [];

  // Cart
  List<CartItem> items = [];
  Cart? cartData;
  List<Discount> coupons = [];
  List<OrderHistory> orders = [];

  // E-notes
  List<EnoteBanner> enotesBanner = [];
  List<EnotesSection> enotesSection = [];
  List<Chapter> enotesChapterList = [];
  EnotesDetails? enotesDetails;

  // Advertisement
  List<Advertisement> advertisements = [];
  List<AdvertisementBanner>? advertisementBanners = [];

  // User
  Profile? profile;
  writer? writerDetails;
  List<NotificationItem> notifications = [];
  RewardResult? rewardResult;

  // UI state
  int currentIndex = 0;
  int currentCategory = 0;
  int currentTab = 0;
  int libraryTab = 0;
  String title = '';

  List<LibraryBookDetailsModel> get library => _library;

  List<LibraryBookDetailsModel> get specificLibraryBooks =>
      _specificLibraryBooks;

  void clearAllData() {
    cartBooks.clear();
    myBooks.clear();
    searchResults.clear();
    bookmarks.clear();
    items.clear();
    orders.clear();
    notifications.clear();
    cartData = null;
    profile = null;
    notifyListeners();
  }

  void _notifyChange<T>(T Function() action) {
    action();
    notifyListeners();
  }

  // Optimized setters using _notifyChange
  void setEnotesDetails(EnotesDetails data) =>
      _notifyChange(() => enotesDetails = data);
  void setBookDetails(Book data) => _notifyChange(() => details = data);
  void setTitle(String txt) => _notifyChange(() => title = txt);
  void setCurrentTab(int i) => _notifyChange(() => currentTab = i);
  void setProfile(Profile data) => _notifyChange(() => profile = data);
  void setProfileClear() => _notifyChange(() => profile = null);
  void setMyBooks(List<Book> list) => _notifyChange(() => myBooks = list);
  void setRewards(RewardResult data) =>
      _notifyChange(() => rewardResult = data);
  void setEnotesCategories(List<EnotesCategory> list) =>
      _notifyChange(() => enotes = list);
  void setEnotesBanner(List<EnoteBanner> list) =>
      _notifyChange(() => enotesBanner = list);
  void setEnotesSection(List<EnotesSection> list) =>
      _notifyChange(() => enotesSection = list);
  void setEnotesList(List<Book> list) => _notifyChange(() => enotesList = list);
  void setEnotesChapterList(List<Chapter> list) =>
      _notifyChange(() => enotesChapterList = list);
  void setLibraryBooks(List<LibraryBookDetailsModel> list) =>
      _notifyChange(() => _library = list);

  void setSpecificLibraryBooks(List<LibraryBookDetailsModel> books) =>
      _notifyChange(() => _specificLibraryBooks = books);
  void setLibraries(List<Library> list) =>
      _notifyChange(() => libraries = list);

  void setPublicLibraries(List<Library> list) =>
      _notifyChange(() => publicLibraries = list);
  void setSearchResult(List<Book> list) =>
      _notifyChange(() => searchResults = list);
  void setHistory(List<OrderHistory> list) =>
      _notifyChange(() => orders = list);
  void setCartData(Cart data) => _notifyChange(() => cartData = data);
  void setLibraryTab(int i) => _notifyChange(() => libraryTab = i);
  void setToCart(List<CartItem> list) => _notifyChange(() => items = list);
  void setCupons(List<Discount> list) => _notifyChange(() => coupons = list);

  void setIndex(int i) => _notifyChange(() {
        print("📍 NAVIGATION INDEX: Changing from $currentIndex to $i");
        print("📍 STACK TRACE: ${StackTrace.current}");
        currentIndex = i;
      });
  void setCategory(int i) => _notifyChange(() => currentCategory = i);
  void setWriterDetails(writer? writer) =>
      _notifyChange(() => writerDetails = writer);
  void setNotifications(List<NotificationItem> data) =>
      _notifyChange(() => notifications = data);

  void setAdBanner(List<Advertisement> list) =>
      _notifyChange(() => advertisements = list);

  void setAdvertisementBanners(List<AdvertisementBanner> list) =>
      _notifyChange(() => advertisementBanners = list);

  void addToCart(Book book) => _notifyChange(() {
        cartBooks.add(book);
        Fluttertoast.showToast(msg: "Added to Cart");
      });

  void setToBookmarks(List<BookmarkItem> books) =>
      _notifyChange(() => bookmarks = books);

  void addCategoryList(List<BookCategory> list) =>
      _notifyChange(() => categoryList.add(list));

  void addBannerList(List<Book> list) =>
      _notifyChange(() => bannerList?.add(list));

  void setBannerList(List<List<Book>> list) =>
      _notifyChange(() => bannerList = list);

  void setBannerListAt(int index, List<Book> list) => _notifyChange(() {
        if (bannerList != null && index >= 0 && index < bannerList!.length) {
          bannerList![index] = list;
        }
      });

  void setFormats(List<BookFormat> list) => _notifyChange(() {
        formats = list ?? [];
        formats?.add(BookFormat(3, "E-Notes", "E-Notes"));
      });
}
