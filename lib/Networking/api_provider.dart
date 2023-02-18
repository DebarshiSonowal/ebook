import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ebook/Model/add_review.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../Helper/navigator.dart';
import '../Model/apply_cupon.dart';
import '../Model/book_category.dart';
import '../Model/book_chapter.dart';
import '../Model/book_details.dart';
import '../Model/book_format.dart';
import '../Model/bookmark.dart';
import '../Model/cart_item.dart';
import '../Model/discount.dart';
import '../Model/filter.dart';
import '../Model/generic_response.dart';
import '../Model/home_banner.dart';
import '../Model/home_section.dart';
import '../Model/login_response.dart';
import '../Model/logout_response.dart';
import '../Model/magazine_plan.dart';
import '../Model/my_books_response.dart';
import '../Model/my_lang.dart';
import '../Model/order.dart';
import '../Model/order_history.dart';
import '../Model/profile.dart';
import '../Model/razorpay_key.dart';
import '../Model/review.dart';
import '../Model/search_response.dart';
import '../Model/writer.dart';

class ApiProvider {
  ApiProvider._();

  static final ApiProvider instance = ApiProvider._();

  final String baseUrl = "https://tratri.in/api";
  final String path = "/books";

  Dio? dio;

  Future<GenericResponse> addSubscriber(
      fname, lname, email, mobile, dob, password) async {
    var data = {
      "f_name": fname,
      "l_name": lname,
      "email": email,
      "mobile": mobile,
      "date_of_birth": dob,
      "password": password
    };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    var url = "${baseUrl}/subscribers";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("add Subscriber response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("add Subscriber error: ${response?.data}");
        return GenericResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("add Subscriber response: ${e.response}");
      return GenericResponse.withError(e.message.toString());
    }
  }

  Future<LoginResponse> loginSubscriber(mobile, password) async {
    var data = {
      "mobile": mobile,
      "password": password,
    };
    var url = "${baseUrl}/subscribers/login";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(data.toString());

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("login Subscriber response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return LoginResponse.fromJson(response?.data);
      } else {
        debugPrint("login Subscriber error: ${response?.data}");
        return LoginResponse.withError("something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("login Subscriber response error: ${e.response?.data}");
      return LoginResponse.withError(e.response?.data['message']);
    }
  }

  Future<GenericResponse> addressSubscriber(email, password) async {
    var data = {
      "email": email,
      "password": password,
    };
    var url = "${baseUrl}/subscribers/address";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("address Subscriber response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("address Subscriber error: ${response?.data}");
        return GenericResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("address Subscriber response: ${e.response}");
      return GenericResponse.withError(e.message.toString());
    }
  }

  Future<ProfileResponse> getProfile() async {
    var url = "${baseUrl}/subscribers/profile";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("profile response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ProfileResponse.fromJson(response?.data);
      } else {
        debugPrint("profile error: ${response?.data}");
        return ProfileResponse.withError();
      }
    } on DioError catch (e) {
      debugPrint("profile response: ${e.response}");
      return ProfileResponse.withError();
    }
  }

  Future<GenericResponse> updateProfile(
      String name, String email, String mobile, String date) async {
    var url = "${baseUrl}/subscribers/profile";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    var data = {
      "f_name": name.split(" ")[0] ?? "",
      "l_name": name.split(" ")[1] ?? "",
      "email": email,
      "mobile": mobile,
      "date_of_birth": date,
    };
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(data.toString());

    try {
      Response? response = await dio?.post(
        url,
        data: jsonEncode(data),
      );
      debugPrint("profile response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("profile error: ${response?.data}");
        return GenericResponse.withError("Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("profile response: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<LogoutResponse> logout() async {
    var url = "${baseUrl}/subscribers/logout";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("profile response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return LogoutResponse.fromJson(response?.data);
      } else {
        debugPrint("profile error: ${response?.data}");
        return LogoutResponse.withError("Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("profile response: ${e.response}");
      return LogoutResponse.withError(e.message);
    }
  }

  Future<Filter> getFilters(format) async {
    var url = "${baseUrl}/search-filters/${format}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("profile response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return Filter.fromJson(response?.data);
      } else {
        debugPrint("profile error: ${response?.data}");
        return Filter.withError("Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("profile response: ${e.response}");
      return Filter.withError(e.message);
    }
  }

  Future<GenericResponse> updateAddressSubscriber(
      old_email, new_email, password) async {
    var data = {
      "email": new_email,
      "password": password,
    };
    var url = "${baseUrl}/subscribers/address/${old_email}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("updateAddress Subscriber response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("updateAddress Subscriber error: ${response?.data}");
        return GenericResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("updateAddress Subscriber response: ${e.response}");
      return GenericResponse.withError(e.message.toString());
    }
  }

  Future<GenericResponse> setPrimaryAddressSubscriber(email, password) async {
    var data = {
      "email": email,
      "password": password,
    };
    var url = "${baseUrl}/subscribers/address/${email}/primary";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("setPrimaryAddress Subscriber response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("setPrimaryAddress Subscriber error: ${response?.data}");
        return GenericResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("setPrimaryAddress Subscriber response: ${e.response}");
      return GenericResponse.withError(e.message.toString());
    }
  }

  Future<GenericResponse> deleteAddressSubscriber(email, password) async {
    var data = {
      "email": email,
      "password": password,
    };
    var url = "${baseUrl}/subscribers/address/${email}/delete";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("deleteAddress Subscriber response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("deleteAddress Subscriber error: ${response?.data}");
        return GenericResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("delete Address Subscriber response: ${e.response}");
      return GenericResponse.withError(e.message.toString());
    }
  }

  Future<BookFormatResponse> fetchBookFormat() async {
    var url = "${baseUrl}${path}/formats";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());

    try {
      Response? response = await dio?.get(url);
      debugPrint("book format response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return BookFormatResponse.fromJson(response?.data);
      } else {
        debugPrint("book format error: ${response?.data}");
        return BookFormatResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("book format response: ${e.response}");
      return BookFormatResponse.withError(e.message.toString());
    }
  }

  Future<BookCategoryResponse> fetchBookCategory(String format) async {
    var url = "${baseUrl}$path/categories/${format}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("book category response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return BookCategoryResponse.fromJson(response?.data);
      } else {
        debugPrint("book category error: ${response?.data}");
        return BookCategoryResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("book category response: ${e.response}");
      return BookCategoryResponse.withError(e.message.toString());
    }
  }

  Future<HomeBannerResponse> fetchHomeBanner(String format) async {
    var url = "${baseUrl}$path/home-banners/${format}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("home-banners response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return HomeBannerResponse.fromJson(response?.data);
      } else {
        debugPrint("home-banners error: ${response?.data}");
        return HomeBannerResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("home-banners response: ${e.response}");
      return HomeBannerResponse.withError(e.message.toString());
    }
  }

  Future<HomeSectionResponse> fetchHomeSections(String format) async {
    var url = "${baseUrl}$path/home-sections/${format}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("home-sections response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return HomeSectionResponse.fromJson(response?.data);
      } else {
        debugPrint("home-sections error: ${response?.data}");
        return HomeSectionResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("home-sections response: ${e.response}");
      return HomeSectionResponse.withError(e.message.toString());
    }
  }

  Future<BookDetailsResponse> fetchBookDetails(String id) async {
    var url = "${baseUrl}$path/detail/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("BookDetails response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return BookDetailsResponse.fromJson(response?.data);
      } else {
        debugPrint("BookDetails error: ${response?.data}");
        return BookDetailsResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("BookDetails response: ${e.response}");
      return BookDetailsResponse.withError(e.message.toString());
    }
  }

  Future<BookChapterResponse> fetchBookChapters(String id) async {
    var url = "${baseUrl}$path/chapters/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("BookDetails response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return BookChapterResponse.fromJson(response?.data);
      } else {
        debugPrint("BookDetails error: ${response?.data}");
        return BookChapterResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("BookDetails response: ${e.response}");
      return BookChapterResponse.withError(e.message.toString());
    }
  }

  Future<ReviewResponse> fetchReview(String id) async {
    var url = "${baseUrl}$path/reviews/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("Book reviews response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ReviewResponse.fromJson(response?.data);
      } else {
        debugPrint("Book reviews error: ${response?.data}");
        return ReviewResponse.withError();
      }
    } on DioError catch (e) {
      debugPrint("Book reviews response: ${e.response}");
      return ReviewResponse.withError();
    }
  }

  Future<BookmarkResponse> fetchBookmark() async {
    var url = "${baseUrl}$path/bookmark/list";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("bookmark response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return BookmarkResponse.fromJson(response?.data);
      } else {
        debugPrint("bookmark error: ${response?.data}");
        return BookmarkResponse.withError("Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("bookmark response: ${e.response}");
      return BookmarkResponse.withError(e.message);
    }
  }

  Future<MagazinePlanResponse> fetchMagazinePlan(String id) async {
    var url = "${baseUrl}/magazines/plans/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("magazines plans response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return MagazinePlanResponse.fromJson(response?.data);
      } else {
        debugPrint("magazines plans error: ${response?.data}");
        return MagazinePlanResponse.withError("Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("magazines plans response: ${e.response}");
      return MagazinePlanResponse.withError(e.message);
    }
  }

  Future<GenericResponse> addReview(Add_Review review, int id) async {
    var url = "${baseUrl}$path/reviews/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    var data = {
      'subscriber_id': review.subscriber_id,
      'content': review.content,
      'rating': review.rating,
    };
    debugPrint(url.toString());
    try {
      Response? response =
          await dio?.post(url.toString(), data: jsonEncode(data));
      debugPrint("Book reviews response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("Book reviews error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("Book reviews response: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> addBookmark(int id) async {
    var url = "${baseUrl}$path/bookmark/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    // var data = {
    //   'book_id': id,
    // };
    debugPrint(url.toString());
    try {
      Response? response = await dio?.post(
        url.toString(),
      );
      debugPrint("Bookmark response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("Bookmark error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("Bookmark response: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> verifyPayment(
      order_id, razorpay_payment_id, amount) async {
    var url = "${baseUrl}/sales/order/verify-payment";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    var data = {
      'order_id': order_id,
      'razorpay_payment_id': razorpay_payment_id,
      'amount': amount,
    };
    debugPrint(url.toString());
    debugPrint(data.toString());
    try {
      Response? response = await dio?.post(
        url.toString(),
        data: jsonEncode(data),
      );
      debugPrint("Bookmark response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("Bookmark error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("Bookmark response: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<CartResponse> addToCart(id, qty) async {
    var url = "${baseUrl}/sales/cart/add";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    var data = {
      'id': id,
      'qty': qty,
    };
    debugPrint(url.toString());
    debugPrint(data.toString());
    try {
      Response? response =
          await dio?.post(url.toString(), data: jsonEncode(data));
      debugPrint("addToCart response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return CartResponse.fromJson(response?.data);
      } else {
        debugPrint("addToCart error: ${response?.data}");
        return CartResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("addToCart error: ${e.response}");
      return CartResponse.withError(e.message);
    }
  }

  Future<CartResponse> fetchCart() async {
    var url = "${baseUrl}/sales/cart";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("Cart response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return CartResponse.fromJson(response?.data);
      } else {
        debugPrint("Cart error: ${response?.data}");
        return CartResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("Cart error: ${e.response}");
      return CartResponse.withError(e.message);
    }
  }

  Future<DiscountResponse> fetchDiscount() async {
    var url = "${baseUrl}/discount/list";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("discount list response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return DiscountResponse.fromJson(response?.data);
      } else {
        debugPrint("discount list error: ${response?.data}");
        return DiscountResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("discount list error: ${e.response}");
      return DiscountResponse.withError(e.message);
    }
  }

  Future<ApplyCupon> applyDiscount(coupon_code, total_amount) async {
    var url = "${baseUrl}/discount/list";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    var data = {
      'total_amount': total_amount,
      'coupon_code': coupon_code,
    };
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));
    try {
      Response? response =
          await dio?.get(url.toString(), queryParameters: data);
      debugPrint("discount apply response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ApplyCupon.fromJson(response?.data);
      } else {
        debugPrint("discount apply error: ${response?.data}");
        return ApplyCupon.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("discount apply error: ${e.response}");
      return ApplyCupon.withError(e.message);
    }
  }

  Future<MyBooksResponse> fetchMyBooks() async {
    var url = "${baseUrl}${path}/my-list";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("my books list response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return MyBooksResponse.fromJson(response?.data);
      } else {
        debugPrint("my books list error: ${response?.data}");
        return MyBooksResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("my books list error: ${e.response}");
      return MyBooksResponse.withError(e.message);
    }
  }

  Future<RazorpayResponse> fetchRazorpay() async {
    var url = "${baseUrl}/payment-gateway";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("Razorpay response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return RazorpayResponse.fromJson(response?.data);
      } else {
        debugPrint("Razorpay error: ${response?.data}");
        return RazorpayResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("Razorpay error: ${e.response}");
      return RazorpayResponse.withError(e.message);
    }
  }

  Future<MyLangResponse> fetchLanguages() async {
    var url = "${baseUrl}/languages";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("languages response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return MyLangResponse.fromJson(response?.data);
      } else {
        debugPrint("languages error: ${response?.data}");
        return MyLangResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("languages error: ${e.response}");
      return MyLangResponse.withError(e.message);
    }
  }

  Future<OrderHistoryResponse> fetchOrders() async {
    var url = "${baseUrl}/sales/order";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("history response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return OrderHistoryResponse.fromJson(response?.data);
      } else {
        debugPrint("history error: ${response?.data}");
        return OrderHistoryResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("history error: ${e.response}");
      return OrderHistoryResponse.withError(e.message);
    }
  }

  Future<WriterResponse> fetchWriterDetails(id) async {
    var url = "${baseUrl}/writer/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("writer response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return WriterResponse.fromJson(response?.data);
      } else {
        debugPrint("writer error: ${response?.data}");
        return WriterResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("writer error: ${e.response}");
      return WriterResponse.withError(e.message);
    }
  }

  Future<CartResponse> updateCart(int id, int qty) async {
    var url = "${baseUrl}/sales/cart/update";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    var data = {
      'id': id,
      'qty': qty,
    };
    debugPrint(url.toString());
    try {
      Response? response =
          await dio?.post(url.toString(), data: jsonEncode(data));
      debugPrint("updateCart response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return CartResponse.fromJson(response?.data);
      } else {
        debugPrint("updateCart error: ${response?.data}");
        return CartResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("updateCart error: ${e.response}");
      return CartResponse.withError(e.message);
    }
  }

  Future<SearchResponse> search(
      format, category_ids, tag_ids, author_ids, title, awards) async {
    var url = "${baseUrl}/search/${format}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    var data = {
      'format': format,
    };
    if (category_ids != null && category_ids != "") {
      var temp = {
        'category_ids': category_ids,
      };
      data.addEntries(temp.entries);
    }
    if (tag_ids != null && tag_ids != "") {
      var temp = {
        'tag_ids': tag_ids,
      };
      data.addEntries(temp.entries);
    }
    if (author_ids != null && author_ids != "") {
      var temp = {
        'author_ids': author_ids,
      };
      data.addEntries(temp.entries);
    }
    if (title != null && title != "") {
      var temp = {
        'title': title,
      };
      data.addEntries(temp.entries);
    }
    if (awards != null && awards != "") {
      var temp = {
        'award_ids': awards,
      };
      data.addEntries(temp.entries);
    }
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));
    try {
      Response? response = await dio?.get(
        url.toString(),
        queryParameters: data,
      );
      debugPrint("search response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return SearchResponse.fromJson(response?.data);
      } else {
        debugPrint("search error: ${response?.data}");
        return SearchResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("search error: ${e.response}");
      return SearchResponse.withError(e.message);
    }
  }

  Future<CartResponse> deleteCart(int id) async {
    var url = "${baseUrl}/sales/cart/delete";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    var data = {
      'id': id,
      // 'qty': qty,
    };
    debugPrint(url.toString());
    try {
      Response? response =
          await dio?.post(url.toString(), data: jsonEncode(data));
      debugPrint("deleteCart response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return CartResponse.fromJson(response?.data);
      } else {
        debugPrint("deleteCart error: ${response?.data}");
        return CartResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("deleteCart error: ${e.response}");
      return CartResponse.withError(e.message);
    }
  }

  Future<OrderResponse> createOrder(
      String coupon_code, direct_buy_book_id) async {
    var url = "${baseUrl}/sales/order";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}',
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    var data = direct_buy_book_id == null
        ? {
            'coupon_code': coupon_code,
          }
        : {
            'coupon_code': coupon_code,
            'direct_buy_book_id': direct_buy_book_id,
            // 'qty': qty,
          };
    debugPrint(url.toString());
    debugPrint(data.toString());
    try {
      Response? response;
      if (coupon_code != null && direct_buy_book_id != "") {
        response = await dio?.post(url.toString(), data: jsonEncode(data));
      } else {
        response = await dio?.post(
          url.toString(),
        );
      }
      debugPrint("order response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return OrderResponse.fromJson(response?.data);
      } else {
        debugPrint("order error: ${response?.data}");
        return OrderResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("order error: ${e.response}");
      return OrderResponse.withError(e.message);
    }
  }

  Future download2(int id) async {
    var url = '${baseUrl}/sales/invoice/${id}';
    Navigation.instance.goBack();
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var tempDir = "/storage/emulated/0/Download";
    String fullPath = tempDir + "/${id}.pdf";
    print('full path ${fullPath}');
    try {
      Response? response = await dio?.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int> s
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response?.headers);
      File file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response?.data);
      await raf.close();
      Future.delayed(Duration(seconds: 2), () {
        showCompleteDownload(fullPath);
      });
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('progress channel', 'progress channel',
                channelShowBadge: false,
                importance: Importance.max,
                priority: Priority.high,
                onlyAlertOnce: true,
                showProgress: true,
                maxProgress: total,
                progress: received);
        final NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0, 'Saving Invoice', 'Downloading', platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  void showCompleteDownload(fullPath) async {
    debugPrint("Completed");
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll().then((value) async {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'progress channel',
        'progress channel',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: false,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(1, 'Invoice Downloaded',
          'Saved Successfully', platformChannelSpecifics,
          payload: fullPath);
    });
  }
}
