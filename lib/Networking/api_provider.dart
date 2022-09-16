import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebook/Model/add_review.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/book_category.dart';
import '../Model/book_chapter.dart';
import '../Model/book_details.dart';
import '../Model/book_format.dart';
import '../Model/bookmark.dart';
import '../Model/cart_item.dart';
import '../Model/discount.dart';
import '../Model/generic_response.dart';
import '../Model/home_banner.dart';
import '../Model/home_section.dart';
import '../Model/login_response.dart';
import '../Model/logout_response.dart';
import '../Model/magazine_plan.dart';
import '../Model/my_books_response.dart';
import '../Model/order.dart';
import '../Model/order_history.dart';
import '../Model/profile.dart';
import '../Model/razorpay_key.dart';
import '../Model/review.dart';

class ApiProvider {
  ApiProvider._();

  static final ApiProvider instance = ApiProvider._();

  final String baseUrl = "https://tratri.in/api";
  final String path = "/books";

  Dio? dio;

  BaseOptions option =
      BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Storage.instance.token}',
    // 'APP-KEY': ConstanceData.app_key
  });

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
        return LoginResponse.withError();
      }
    } on DioError catch (e) {
      debugPrint("login Subscriber response: ${e.response}");
      return LoginResponse.withError();
    }
  }

  Future<GenericResponse> addressSubscriber(email, password) async {
    var data = {
      "email": email,
      "password": password,
    };
    var url = "${baseUrl}/subscribers/address";
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
    dio = Dio(option);
    debugPrint(url.toString());

    try {
      Response? response = await dio?.post(
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

  Future<LogoutResponse> logout() async {
    var url = "${baseUrl}/subscribers/logout";
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

  Future<GenericResponse> updateAddressSubscriber(
      old_email, new_email, password) async {
    var data = {
      "email": new_email,
      "password": password,
    };
    var url = "${baseUrl}/subscribers/address/${old_email}";
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

  Future<MyBooksResponse> fetchMyBooks() async {
    var url = "${baseUrl}${path}/my-list";
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

  Future<OrderHistoryResponse> fetchOrders() async {
    var url = "${baseUrl}/sales/order";
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

  Future<CartResponse> updateCart(int id, int qty) async {
    var url = "${baseUrl}/sales/cart/update";
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

  Future<CartResponse> deleteCart(int id) async {
    var url = "${baseUrl}/sales/cart/delete";
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

  Future<OrderResponse> createOrder(String coupon_code) async {
    var url = "${baseUrl}/sales/order";
    dio = Dio(option);
    var data = {
      'coupon_code': coupon_code,
      // 'qty': qty,
    };
    debugPrint(url.toString());
    try {
      Response? response;
      if (coupon_code != null && coupon_code != "") {
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
}
